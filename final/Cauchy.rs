use std::fmt;
use std::ops;
use std::cmp;

pub struct CauchyList {
    pub p: i32,
    pub content: Vec<i32>
}

impl CauchyList {
    // CauchyList methods go here, if desired!
}

impl cmp::PartialEq for CauchyList {
    fn eq(&self, other: &Self) -> bool {    
        // Implement == operation here
    }
}

impl ops::Add<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn add(self, other: CauchyList) -> CauchyList {
        // Implement + operation here
    }
}

impl ops::Sub<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn sub(self, other: CauchyList) -> CauchyList {
        // Implement - operation here
    }
}

impl ops::Mul<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn mul(self, other: CauchyList) -> CauchyList {
        // Implement * operation here
    }
}

impl ops::Mul<i32> for CauchyList {
    type Output = CauchyList;
    fn mul(self, other: i32) -> CauchyList {
        // Implement * operation here
    }
}

impl fmt::Display for CauchyList {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {    
        // Implement print formatting here       
    }
}