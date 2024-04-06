//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    
    private var taskRepository: TaskRepository
    
    @Published var tasks: [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var _isCompleted: Bool = false
    var shouldDismiss = PassthroughSubject<Bool, Never>()
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    deinit {
        cancelSubscribtion()
    }
    
    func cancelSubscribtion() {
        cancellable.forEach({$0.cancel()})
    }
    
    func getTasks(isCompleted: Bool) {
        _isCompleted = isCompleted
        taskRepository.get(isCompleted: !isCompleted)
            .sink { [weak self] fetchOperationResult in
                switch fetchOperationResult {
                case .success(let fetchedTask):
                    self?.errorMessage = ""
                    self?.tasks = fetchedTask
                case .failure(let failure):
                    self?.errorMessage = self?.processError(failure) ?? ""
                }
            }.store(in: &cancellable)
    }
    
    func addTask(task: Task) {
        taskRepository.add(task: task)
            .sink { [weak self] addTaskResult in
                self?.processOperationResult(operationResult: addTaskResult)
        }.store(in: &cancellable)
    }
    
    func updateTask(task: Task) {
        taskRepository.update(task: task).sink { [weak self] updateTaskResult in
            self?.processOperationResult(operationResult: updateTaskResult)
        }.store(in: &cancellable)
    }
    
    func deleteTask(task: Task) {
        taskRepository.delete(task: task)
            .sink { [weak self] deleteTaskResult in
                self?.processOperationResult(operationResult: deleteTaskResult)
            }.store(in: &cancellable)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) {
        switch operationResult {
        case .success(_):
            self.errorMessage = ""
            self.getTasks(isCompleted: _isCompleted)
            self.shouldDismiss.send(true)
        case .failure(let failure):
            self.errorMessage = self.processError(failure)
            self.shouldDismiss.send(false)
        }
    }
    
    private func processError(_ error: TaskRepositoryError) -> String {
        switch error {
        case .operationFailure(let errorMessage):
            showError = true
            return errorMessage
        }
    }
}
