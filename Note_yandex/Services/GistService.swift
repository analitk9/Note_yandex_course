//
//  GistService.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 06/08/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation

class GistService {
    
    let notebookService = NotebookService()
    
    /// запрос gist по id для обновления файла ios-course-notes-db
    func getGist(from id: String)-> Gist? {
        var gistRez: Gist?
        
        let url = URL(string: "https://api.github.com/gists/\(id)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "no description")
                return
            }
            guard let data = data else {return}
            if  let gist = try? JSONDecoder().decode(Gist.self, from: data) {
                gistRez = gist
            }
            
        }
        task.resume()
        return gistRez
    }
    
    // эксперементальная версия   completion: ((URL)->Void)?
    func getGist(by url: URL, completion: @escaping ((URL?)->Void)) {
        guard let token = KeychainWrapper.standard.string(forKey: "SecretToken") else { return  }
        var rawUrl: URL?
        //  guard let url = URL(string: stringUrl) else {return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: request){ data,response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "no description")
                return
            }
            if let response = response as? HTTPURLResponse {
                if   response.statusCode < 400  {
                    guard let data = data else { return }
                    
                    if let gistInfo = try? JSONDecoder().decode(Gist.self, from: data) {
                    
                      rawUrl = self.returnRawUrl(gists: [gistInfo])!

                    }else {print("ошибка") }
                }
            }
            completion(rawUrl)
        }
        task.resume()
        
    }
    // эксперементальная версия  completion: ((FileNotebook)->Void)?
    func getNotebook(from url: URL?, completion: @escaping (FileNotebook?)->Void ){
        
        var notebook:FileNotebook?
        guard let url = url else {
            completion(nil)
            return
        }
        guard let token = KeychainWrapper.standard.string(forKey: "SecretToken") else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "no description")
                return
            }
            if let response = response as? HTTPURLResponse {
                if   response.statusCode < 400  {
                    guard let data = data else { return }
                    
                    let js = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    notebook = FileNotebook()
                    notebook!.fillbyDict(notesDict: self.notebookService.parse(from: js!))
                }
            }
            
            completion(notebook)
            
        }
        
        task.resume()
    }
    //
    //    func getNotebook(from url: URL)-> FileNotebook {
    //        let notebook = FileNotebook()
    //        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    //            guard error == nil else {
    //                print(error?.localizedDescription ?? "no description")
    //                return
    //            }
    //            guard let data = data else {return}
    //            if let js = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
    //                notebook.fillbyDict(notesDict: self.notebookService.parse(from: js))
    //            }
    //        }
    //        task.resume()
    //
    //        return notebook
    //
    //    }
    
    ///запрос полного списка gist
    func getGists(completion: @escaping (([Gist]?)-> Void) ) {
        var gists: [Gist]?
        guard let token = KeychainWrapper.standard.string(forKey: "SecretToken")
            else {return }
        
        var request = URLRequest(url: URL(string: "https://api.github.com/gists")!)
        request.addValue( "token \(token)", forHTTPHeaderField: "Authorization")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = URLSession.shared.dataTask(with: request){ data,response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "no description")
                return
            }
            if let response = response as? HTTPURLResponse{
                if response.statusCode < 400 {
                    guard let data = data else { return }
                    
                     gists = try? JSONDecoder().decode([Gist].self, from: data)
                   // print(gists)
                }
            }
            completion(gists)
        }
        
        task.resume()
       
       
    }
    //    /// возвращает gist по id
    //    func getGist(by url: String) -> Gist? {
    //        var gist: Gist?
    //        guard let token = KeychainWrapper.standard.string(forKey: "SecretToken") else { return nil }
    //        let  compUrl = url
    //        guard let url = URL(string: compUrl) else {return nil}
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    //        request.cachePolicy = .reloadIgnoringLocalCacheData
    //        let task = URLSession.shared.dataTask(with: request){ data,response, error in
    //            guard let data = data else { return  }
    //            let gistInfo = try? JSONDecoder().decode(Gist.self, from: data)
    //
    //            if let gistInfo = gistInfo {
    //                print("get task by id \(gistInfo)")
    //
    //                gist = gistInfo
    //            }
    //        }
    //
    //        task.resume()
    //        return gist
    //    }
    
    
    ///возвращает из массива gist`ов ссылку(url) на файл ios-course-notes-db
    func returnRawUrl(gists: [Gist])->URL? {
        if let gist = gists.first(where: {$0.files.keys.contains("ios-course-notes-db")}){
            let fileDict = gist.files
            for (key, value) in fileDict {
                if key == "ios-course-notes-db" {
                    let urlString = value.rawUrl
                    KeychainWrapper.standard.set(gist.url, forKey: "url")
                    return URL(string: urlString)
                }
            }
        }
        return nil
    }
    
    ///создает из fileNotebook нужную структуру gist для опубликования
    func createGist(notebook: FileNotebook)-> PostGist? {
        //создаем данные для нового файла
        let json =  notebookService.createJson(from: notebook.notes)
        
        guard let postData = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }
        
        let newFile = FileGistJson(content: String(bytes: postData, encoding: .utf8)!  )
        let newGist = PostGist(public: true, description: "ios-course-notes-db", files: ["ios-course-notes-db" : newFile]) 
        
        return newGist
    }
    
    /// постит gist структуру на сервер гита (если есть url то перезапишем по адресу)
    func post(gist: PostGist, by url: String?) -> Bool {
        
        guard let token = KeychainWrapper.standard.string(forKey: "SecretToken") else { return  false }
        var compUrl: String
        var result: Bool = true
        if let url = url {
            compUrl = url
        }else {
            compUrl = "https://api.github.com/gists"
        }
        
        let stringURL = compUrl
        guard let url = URL(string: stringURL) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //при записи существующего гиста делает перезапись, можно и без patch
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        do{
            request.httpBody = try JSONEncoder().encode(gist)
        }
        catch let error {
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "no description")
                return 
            }
            if let response = response as? HTTPURLResponse{
                if response.statusCode < 400 {
                    guard let data = data else { return }
                    if let gistInfo = try? JSONDecoder().decode(Gist.self, from: data) {
                        KeychainWrapper.standard.set(gistInfo.url, forKey: "url")
                        
                    }
                    print("должно быть норм - 201 и пришло -  \( response.statusCode)")
                    result = true
                    
                }else {
                    print("что то пошло не так!!!!!     \(response.statusCode)")
                    result = false
                }
            }
            
            }.resume()
        
        return result
        
    }
    
}
