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
