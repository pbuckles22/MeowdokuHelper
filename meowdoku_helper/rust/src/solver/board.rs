pub const EMPTY: u8 = 0;
pub const CAT: u8 = 1;
pub const BLOCKED: u8 = 2;

pub struct Board {
    pub state: Vec<u8>,
    pub regions: Vec<u8>,
    size: u32,
}

impl Board {
    pub fn new(state: Vec<u8>, regions: Vec<u8>, size: u32) -> Self {
        let expected = (size * size) as usize;
        debug_assert_eq!(state.len(), expected);
        debug_assert_eq!(regions.len(), expected);
        Self {
            state,
            regions,
            size,
        }
    }

    pub fn size(&self) -> u32 {
        self.size
    }

    pub fn idx(&self, x: usize, y: usize) -> usize {
        y * self.size as usize + x
    }

    pub fn coord(&self, idx: usize) -> (usize, usize) {
        let n = self.size as usize;
        (idx % n, idx / n)
    }

    pub fn get(&self, x: usize, y: usize) -> u8 {
        self.state[self.idx(x, y)]
    }

    pub fn set(&mut self, x: usize, y: usize, value: u8) {
        let idx = self.idx(x, y);
        self.state[idx] = value;
    }

    pub fn region_at(&self, x: usize, y: usize) -> u8 {
        self.regions[self.idx(x, y)]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn idx_and_coord_round_trip_at_nine() {
        let board = Board::new(vec![EMPTY; 81], vec![1; 81], 9);
        for y in 0..9 {
            for x in 0..9 {
                let idx = board.idx(x, y);
                assert_eq!(board.coord(idx), (x, y));
            }
        }
    }
}
