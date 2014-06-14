//
//  main.swift
//  Waiting-Room
//
//  Created by Romain Pouclet on 2014-06-13.
//  Copyright (c) 2014 Perfectly Cooked. All rights reserved.
//

import Foundation

func fetchFact() {
    let session = NSURLSession.sharedSession()
    let request = NSURLRequest(URL: NSURL.URLWithString("http://numbersapi.com/random/year"))
    let fetchTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
        let content = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("FACT:\n\(content)\n")

        // Waiting 2 seconds and fetching a new fact
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue(), {
            fetchFact()
        })
    })
    fetchTask.resume()
}

let args = NSProcessInfo.processInfo()!.arguments

// In case a command was not provided
if args.count == 1 {
    println("Please provide a command to run 😁")
//    exit(1)
}

var over = false

var task = NSTask()
task.launchPath = "/bin/sleep"
task.arguments = ["10"]
task.terminationHandler = {task -> Void in
    println("Task is over \(task.terminationStatus)")
    exit(task.terminationStatus)
}
task.launch()

fetchFact()

while NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture() as NSDate) {}

println("done")

