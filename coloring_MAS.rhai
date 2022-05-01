let mapsize = 40;

fn randint(x) {
    return (rand() % x).abs();
}

fn random_move(w) {
    let r = randint(4);
    switch r {
        0 => worker(w).move_up(),
        1 => worker(w).move_down(),
        2 => worker(w).move_right(),
        3 => worker(w).move_left(),
    }
}


fn nearest_good(w, map) {
    let x =  worker(w).x;
    let y =  worker(w).y;
    let queue = [[x, y]];
    let head = 1;
    let tail = 0;
    let mycolor = worker(w).color;

    while (tail < head) {
        let cx = queue[tail][0];
        let cy = queue[tail][1];
        tail = tail + 1;

        if (map[cx][cy] != mycolor) {
            if randint(5) != 0 {
                print(`found ${map[cx][cy]} at ${cx}, ${cy}`);
                return [cx, cy];
            }
        }

        let a = [[1, 0], [0, 1], [-1, 0], [0, -1]];
        a.shuffle();
//         print(a);
        for (dd, count) in a {
            let nx = cx + dd[0];
            let ny = cy + dd[1];

            if (nx < 0 || nx >= 40) {
                continue;
            }
            if (ny < 0 || ny >= 40) {
                continue;
            }
            if [nx, ny] in queue {
                continue;
            }
            queue.push([nx, ny]);
            head = head+1;
        }
    }
    print("No other tile!");
    return [x+1, y]
}

fn go_to(w, x, y, tx, ty) {
    if  y < ty {
        worker(w).move_up();
        return;
    }
    if y > ty {
        worker(w).move_down();
        return;
    }
    if  x < tx {
        worker(w).move_right();
        return;
    }
    if x > tx {
        worker(w).move_left();
        return;
    }
}


fn explore(w, memory, map) {
    let txy = nearest_good(w, map);
    let x = worker(w).x;
    let y = worker(w).y;
    print(`${w} going to ${txy}`);
    go_to(w, x, y, txy[0], txy[1]);
    return memory;
}

fn connect(w, memory, map) {
    random_move(w);
    return memory;
}


fn sabotage(w, memory, map) {
    let ws = `sab${w}`;

    if ws in memory == false { // this is horrible!
        memory[ws] = [randint(40), randint(40)];
    }

    let x = worker(w).x;
    let y = worker(w).y;
    let tx = memory[ws][0];
    let ty = memory[ws][1];
//     print!(`${ws}: ${x}, ${y}, ${tx}, ${ty}`);

    if (x == tx && y == ty) || randint(30) == 0 {
        memory[ws] = [randint(40), randint(40)];
        tx = memory[ws][0];
        ty = memory[ws][1];
    }

    go_to(w, x, y, tx, ty);
    return memory;
}


let roles = [
    Fn("explore"),
    Fn("explore"),
    Fn("explore"),
    Fn("explore"),
    Fn("explore"),
    Fn("explore"),
    Fn("sabotage"),
    Fn("sabotage"),
];


for w in 0..8 {
    memory = roles[w].call(w, memory, map);
}

