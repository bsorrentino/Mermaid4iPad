//
//  AgentExecutorDemo.swift
//
//
//  Created by bsorrentino on 23/03/24.
//

import Foundation
import OSLog
import OpenAI
import LangGraph

fileprivate let _log = Logger(subsystem: "org.bsc.langgraph", category: "agentexecutor")

fileprivate func loadDiagramFromBundle( fileName: String ) throws -> DiagramDescription {
    
    guard let filepath = Bundle.module.path(forResource: fileName, ofType: "json") else {
        throw _EX("json file \(fileName) not found!")
    }
    
    let code =  try String(contentsOfFile: filepath, encoding: .utf8)
    
    let decoder = JSONDecoder()
    
    if let data = code.data(using: .utf8) {
        
        return try decoder.decode(DiagramDescription.self, from: data )
    }
    else {
        throw _EX( "error converting data from \(fileName)!")
    }
}

public func translateDrawingToMermaidWithDiagramDescription<T:AgentExecutorDelegate>(
    fromJSONFile fileName: String,
    withVisionModel visionModel: Model,
    withModel model: Model,
    openAI: OpenAI,
    delegate:T ) async throws -> String? {
    
    
    let channels = [
        "diagram": Channel( reducer:nil, default: {
            try loadDiagramFromBundle( fileName: fileName )
        })
    ]

    
    return try await translateDrawingToMermaid(channels: channels,
                                               stateFactory: { AgentExecutorState($0) },
                                               withVisionModel: visionModel,
                                               withModel: model,
                                               openAI: openAI,
                                               delegate: delegate)
}


