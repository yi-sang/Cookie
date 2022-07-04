//
//  CommonError.swift
//  CornFarmer
//
//  Created by 이상현 on 2022/05/10.
//

struct CommonError: Error, CustomStringConvertible {
  
  let description: String
  
  init(description: String) {
    self.description = description
  }
  
  init(error: Error) {
    self.description = error.localizedDescription
  }
}
