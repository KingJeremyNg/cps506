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
        let length1 = self.content.len();
        let length2 = other.content.len();
        if (length1 == length2) && (self.p == other.p) {
            for i in 0..length1 {
                if self.content[i] != other.content[i] {
                    return false;
                }
            }
            return true;
        }
        else {
            return false;
        }
    }
}

impl ops::Add<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn add(self, other: CauchyList) -> CauchyList {
        let mut list = vec![0; cmp::max(self.content.len(), other.content.len())];
        for i in 0..cmp::max(self.content.len(), other.content.len()) {
            if i > (self.content.len() - 1) {
                list[i] = (other.content[i]) % self.p
            }
            else if i > (other.content.len() - 1) {
                list[i] = (self.content[i]) % self.p
            }
            else {
                list[i] = (self.content[i] + other.content[i]) % self.p;
            }
        }
        return CauchyList {p: self.p, content: list}
    }
}

impl ops::Sub<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn sub(self, other: CauchyList) -> CauchyList {
        let mut list = vec![0; cmp::max(self.content.len(), other.content.len())];
        for i in 0..cmp::max(self.content.len(), other.content.len()) {
            if i > (self.content.len() - 1) {
                list[i] = (other.content[i]) % self.p
            }
            else if i > (other.content.len() - 1) {
                list[i] = (self.content[i]) % self.p
            }
            else {
                list[i] = (self.content[i] - other.content[i]) % self.p;
            }
        }
        return CauchyList {p: self.p, content: list}
    }
}

impl ops::Mul<CauchyList> for CauchyList {
    type Output = CauchyList;
    fn mul(self, other: CauchyList) -> CauchyList {
        let mut answer = vec![0; self.content.len() + other.content.len() - 1];
        let mut list1 = self.content;
        let mut list2 = other.content;
        let mut sample1 = vec![];
        let mut sample2 = vec![];
        let mut acc;
        for i in 0..answer.len() {
            if i > list1.len() - 1 {
                list1.push(0);
            }
            if i > list2.len() - 1 {
                list2.push(0);
            }
        }
        for i in 0..answer.len() {
            acc = 0;
            sample1.push(list1[i]);
            sample2.push(list2[i]);
            for j in 0..sample1.len() {
                acc += sample1[j] * sample2[sample2.len() - j - 1];
            }
            answer[i] = acc % self.p;
        }
        return CauchyList {p: self.p, content: answer}
    }
}

impl ops::Mul<i32> for CauchyList {
    type Output = CauchyList;
    fn mul(self, other: i32) -> CauchyList {
        let mut answer = vec![];
        for i in 0..self.content.len() {
            answer.push((self.content[i] * other) % self.p);
        }
        return CauchyList {p: self.p, content: answer}
    }
}

impl fmt::Display for CauchyList {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {    
        write!(f,"p: {}\nlength: {}\ncontents: {:?}\n", self.p, self.content.len(), self.content)
    }
}
