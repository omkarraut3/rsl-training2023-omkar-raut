import Foundation
import Dispatch

// Task 1
func task1() {
    print("Task 1 started")
    sleep(2)
    print("Task 1 completed")
}

// Task 2
func task2() {
    print("Task 2 started")
    sleep(1)
    print("Task 2 completed")
}

// Main task
func mainTask() {
    print("Main task")

    // Concurrent queue
    let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)

    concurrentQueue.async {
        task1()
    }

    concurrentQueue.async {
        task2()
    }

    // Barrier task will be executed only after previous tasks complete
    concurrentQueue.async(flags: .barrier) {
        print("All tasks completed")
    }
}

mainTask()
