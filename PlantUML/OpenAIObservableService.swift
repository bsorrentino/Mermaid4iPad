//
//  OpenAIService.swift
//  PlantUMLApp
//
//  Created by bsorrentino on 31/12/23.
//

import SwiftUI
import AppSecureStorage
import OpenAI
import PlantUMLFramework
import LangGraph


class OpenAIObservableService : ObservableObject {
    
    enum Status : Equatable {
        case Ready
        case Error( String )
        case Editing
    }

//    let models = ["text-davinci-edit-001", "code-davinci-edit-001"]
    
    @Published public var status: Status = .Ready
    @Published public var inputApiKey = ""
    @Published public var inputOrgId = ""
//    @Published public var inputModel:String

    @AppStorage("openaiModel") private var openAIModel:String = "gpt-3.5-turbo"
    @AppSecureStorage("openaikey") private var openAIKey:String?
    @AppSecureStorage("openaiorg") private var openAIOrg:String?

    var clipboardQueue = LILOFixedSizeQueue<String>( maxSize: 10 )
    var promptQueue = LILOFixedSizeQueue<String>( maxSize: 10 )
    
    
    init() {
        
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !apiKey.isEmpty {
            openAIKey = apiKey
        }
        if let orgId = Bundle.main.object(forInfoDictionaryKey: "OPENAI_ORG_ID") as? String, !orgId.isEmpty  {
            openAIOrg = orgId
        }
        
        inputApiKey = openAIKey ?? ""
        inputOrgId = openAIOrg ?? ""
        
//        inputModel = models[0]
                
//        if let openAIModel {
//            inputModel = openAIModel
//        }
        
     }
    
    func commitSettings() {
        guard !inputApiKey.isEmpty, !inputOrgId.isEmpty else {
            return
        }
        openAIKey = inputApiKey
        openAIOrg = inputOrgId
//        openAIModel = inputModel
        status = .Ready
    }
    
    func resetSettings() {
//        inputModel = models[0]
        inputApiKey = ""
        inputOrgId = ""
        openAIKey = nil
        openAIOrg = nil
    }

    var isSettingsValid:Bool {
        guard let openAIKey, !openAIKey.isEmpty, let openAIOrg, !openAIOrg.isEmpty else {
            return false
        }
        return true
    }

    var openAI: OpenAI? {

        guard let openAIKey  else {
            status = .Error("api key not found!")
            return nil
        }
        guard let openAIOrg  else {
            status = .Error("org id not found!")
            return nil
        }

        let config = OpenAI.Configuration( token: openAIKey, organizationIdentifier: openAIOrg)
        return OpenAI( configuration: config )

    }

    @MainActor
    func query( input: String, instruction: String ) async -> String? {
        
        guard let openAI /*, let  openAIModel */, case .Ready = status else {
            return nil
        }
        
        self.status = .Editing
        
        do {
            
            let query = ChatQuery(
                model: openAIModel,
                messages: [
                    .init(role: .system, content:
                                    """
                                    You are my plantUML assistant.
                                    You must answer exclusively with diagram syntax.
                                    """),
                    .init( role: .assistant, content: input ),
                    .init( role: .user, content: instruction )
                ],
                temperature: 0.0,
                topP: 1.0
            )

            let chat = try await openAI.chats(query: query)

            let result = chat.choices[0].message.content

            if case .string(let content) = result {
                
                status = .Ready
                
                return content
                    .split( whereSeparator: \.isNewline )
                    .filter { $0 != "@startuml" && $0 != "@enduml" }
                    .joined(separator: "\n" )
            }
            
            status = .Error( "invalid result!" )
            
            return nil

        }
        catch {
            
            status = .Error( error.localizedDescription )
            
            return nil
        }
    }
    
    @MainActor
    func vision( imageUrl: String ) async -> String? {
        
        guard let openAI /*, let  openAIModel */, case .Ready = status else {
            return nil
        }

        status = .Editing
        
        do {
            
            if let content = try await agentExecutor( openAI: openAI, imageUrl: imageUrl) {
                
                status = .Ready
                
                return content
                    .split( whereSeparator: \.isNewline )
                    .filter { $0 != "@startuml" && $0 != "@enduml" }
                    .joined(separator: "\n" )
            }
            
            status = .Error( "invalid result!" )
        }
        catch {
            
            status = .Error( error.localizedDescription )
        }

        return nil
    }

}


extension OpenAIObservableService { // LangGraph extension
    
    

        

}

class LILOQueue<T> {
    
    var elements:Array<T> = []
    
    var isEmpty:Bool {
        elements.isEmpty
    }
    
    func push( _ item: T ) {
        elements.append( item )
    }
    
    func pop() -> T? {
        guard  !elements.isEmpty else {
            return nil
        }
        
        return elements.removeLast()
    }
    
    func clear() {
        elements.removeAll()
    }
    
}

class LILOFixedSizeQueue<T> : LILOQueue<T> {
    
    private let size:Int
    
    init( maxSize size: Int ) {
        self.size = size
    }
    
    override func push( _ item: T ) {
        if elements.count == size {
            elements.removeFirst()
        }
        elements.append( item )
    }
    
}
