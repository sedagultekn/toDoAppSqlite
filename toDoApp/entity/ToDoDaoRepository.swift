//
//  repo.swift
//  toDoApp
//
//  Created by Seda Gültekin on 14.08.2023.
//

import Foundation
import RxSwift
class ToDoDaoRepository{
    var toDoList=BehaviorSubject<[ToDo]>(value: [ToDo]())
    let db:FMDatabase?
    init(){
        let dosyaYolu = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniURL = URL(fileURLWithPath: dosyaYolu).appendingPathComponent("toDo.sqlite")
        db = FMDatabase(path: veritabaniURL.path)
    }
    
    func ekle(toDo_title:String,toDo_text:String){
        db?.open()
        do {
            try db!.executeQuery("INSERT INTO toDo (toDo_title,toDo_text) VALUES(?,?)", values: [toDo_title,toDo_text])
        }
        catch{
            print(error.localizedDescription)
            
        }
        db?.close()
    }
    func guncelle(toDo_title:String,toDo_text:String){
        
        db?.open()
        do {
            try db!.executeQuery("UPDATE toDo SET toDo_title=?, toDo_text=? WHERE toDo_title=?", values: [toDo_title,toDo_text])
        }
        catch{
            print(error.localizedDescription)
            
        }
        db?.close()
    }
    
    func sil(toDo_title:String){
        db?.open()
        do {
            try db!.executeQuery("DELETE FROM toDo WHERE toDo_title=?", values: [toDo_title])
        }
        catch{
            print(error.localizedDescription)
            
        }
        db?.close()
        
    }
    func ara(aramaKelimesi :String){
        db?.open()
        var liste = [ToDo]()
        do{
            let result = try db!.executeQuery("SELECT * FROM toDo WHERE toDo_text like '%\(aramaKelimesi)%", values: nil)
            while result.next(){
                let toDo_title = result.string(forColumn: "toDo_title")!
                let toDo_text = result.string(forColumn: "toDo_text")!
                let toDo_id = Int(result.string(forColumn: "toDo_id"))!
                let toDo = ToDo(toDo_title: toDo_title,toDo_text: toDo_text,toDo_id:toDo_id)
                liste.append(toDo)
            }
            toDoList.onNext(liste)
        }catch{
            print(error.localizedDescription)
            
        }
        db?.close()
    }
    
    func yapilacaklariYukle(){
       
       
        db?.open()
        var liste = [ToDo]()
        do{
            let result = try db!.executeQuery("SELECT * FROM toDo", values: nil)
            while result.next(){
                let toDo_title = result.string(forColumn: "toDo_title")!
                let toDo_text = result.string(forColumn: "toDo_text")!
               
                let toDo = ToDo(toDo_title: toDo_title,toDo_text: toDo_text)
                liste.append(toDo)
            }
            toDoList.onNext(liste)
        }catch{
            print(error.localizedDescription)
            
        }
        db?.close()
    }
}
