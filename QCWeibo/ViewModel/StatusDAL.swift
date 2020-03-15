//
//  StatusDAL.swift
//  QCWeibo
//
//  Created by 韦秋岑 on 2020/3/12.
//  Copyright © 2020 weiqiucen. All rights reserved.
//

import Foundation

/// `1 week`
private let kMaxCacheDateTime: TimeInterval = 7 * 24 * 60 * 60

/// `DAL`
class StatusDAL {
    
    class func clearDataCache() {
        
        let date = Date(timeIntervalSinceNow: -kMaxCacheDateTime)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        
        let sql = "DELETE FROM T_Status WHERE createTime < ?;"
        SQLiteManager.shared.queue.inDatabase { (db) in
            if db.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                printQCDebug(message: "删除了 \(db.changes) 条数据")
            }
        }
    }
    
    
    class func loadStatus(since_id: Int, max_id: Int, finished: @escaping (_ array: [[String : Any]]?) -> ()) {
        
        let array = checkCacheData(since_id: since_id, max_id: max_id)
        
        if array!.count > 0 {
            finished(array)
            return
        }
        
        NetworkTool.shared.loadStatus(since_id: Int(since_id), max_id: Int(max_id)) { (result, error) in
            if error != nil {
                printQCDebug(message: "something wrong!")
                finished(nil)
                return
            }
            
            guard let array = result as? [String : Any] else {
                printQCDebug(message: "invalid format!")
                finished(nil)
                return
            }
            
            let array1 = array["statuses"] as! [[String : Any]]
            StatusDAL.saveCacheData(array: array1)
            finished(array1)
        }
        
    }
    
    
    private class func checkCacheData(since_id: Int, max_id: Int) -> [[String : Any]]? {
        
        guard let userId = UserAccountViewModel.shared.account?.uid else {
            printQCDebug(message: "用户没有登录")
            return nil
        }
        
        var sql = "SELECT statusId, status, userId FROM T_Status \n"
        sql += "WHERE userId = \(userId) \n"
        
        if since_id > 0 {
            sql += "    AND statusId > \(since_id) \n"
        } else if max_id > 0 {
             sql += "    AND statusId < \(max_id) \n"
        }
        sql += "ORDER BY statusId DESC LIMIT 20;"
        
        printQCDebug(message: "查询数据SQL ->" + sql)
        
        let array = SQLiteManager.shared.execRecordSet(sql: sql)
        var arrayM = [[String : Any]]()
        
        for dict in array {
            let jsonData = dict["status"] as! Data
            let result = try! JSONSerialization.jsonObject(with: jsonData, options: [])
            arrayM.append(result as! [String : Any])
        }
        return arrayM
    }
    
    
    private class func saveCacheData(array: [[String : Any]]) {
        
        guard let userId = UserAccountViewModel.shared.account?.uid else {
            printQCDebug(message: "用户没有登录")
            return
        }
        
        let sql = "INSERT OR REPLACE INTO T_Status (statusId, status, userId) VALUES (?, ?, ?);"
        
        SQLiteManager.shared.queue.inTransaction { (db, rollback) in
            for dict in array {
                let statusId = dict["id"] as! Int
                let json = try! JSONSerialization.data(withJSONObject: dict, options: [])
                if db.executeUpdate(sql, withArgumentsIn: [statusId, json, userId]) {
                    printQCDebug(message: "数据插入失败")
                    rollback.pointee = true
                    break
                }
            }
        }
        printQCDebug(message: "数据插入完成")
    }
    
}
