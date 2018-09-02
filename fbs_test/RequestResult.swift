//
//  RequestResult.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 02/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation

struct RequestResult<D, E>
{
    let data: D?
    let error: E?
    
    init(withData data: D?)
    {
        self.data = data
        self.error = nil
    }
    
    init(withError error: E?)
    {
        self.data = nil
        self.error = error
    }
}
