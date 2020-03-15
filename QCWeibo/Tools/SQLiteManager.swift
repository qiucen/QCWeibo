//
//  SQLiteManager.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/10.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

private let dbName = "readme.db"

/// `SQLite manager`
class SQLiteManager {
    
    /// `singleton`
    static let shared = SQLiteManager()
    let queue: FMDatabaseQueue
    
    
    func execRecordSet(sql: String) -> [[String : Any]] {
        var result = [[String : Any]]()
        SQLiteManager.shared.queue.inDatabase { (db) in
            guard let rs = try? db.executeQuery(sql, values: nil) else { return }
            while rs.next() {
                let colCount = rs.columnCount
                var dict = [String : Any]()
                for col in 0..<colCount {
                    let name = rs.columnName(for: col)!
                    let obj = rs.object(forColumnIndex: col)
                    dict[name] = obj
                }
                result.append(dict)
            }
        }
        return result
    }
    
    
    private init() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        path = (path as NSString).appendingPathComponent(dbName)
        printQCDebug(message: "数据库路径 \(path)")
        queue = FMDatabaseQueue(path: path)!
        createTable()
    }
    
    
    private func createTable() {
           let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
           let sql = try! String(contentsOfFile: path)
           queue.inDatabase { (db) in
               if db.executeStatements(sql) {
                   printQCDebug(message: "创表成功")
               } else {
                   printQCDebug(message: "创表失败")
               }
           }
       }
       
    
}
