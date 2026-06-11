//! Shared board layouts for solver unit tests.

#[cfg(test)]
pub fn idx(x: usize, y: usize, n: usize) -> usize {
    y * n + x
}

#[cfg(test)]
pub fn checkerboard_regions(size: u32) -> Vec<u8> {
    let n = size as usize;
    (0..n * n)
        .map(|i| {
            let (x, y) = (i % n, i / n);
            (((x + y) % n) + 1) as u8
        })
        .collect()
}

#[cfg(test)]
pub fn quadrant_regions(size: u32) -> Vec<u8> {
    let n = size as usize;
    let half = n / 2;
    (0..n * n)
        .map(|i| {
            let (x, y) = (i % n, i / n);
            let qx = if x < half { 0 } else { 1 };
            let qy = if y < half { 0 } else { 1 };
            (qy * 2 + qx + 1) as u8
        })
        .collect()
}
