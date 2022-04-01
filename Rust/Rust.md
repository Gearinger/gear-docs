# Rust

~~~rust
// 编译
cargo build
// 运行
cargo run
~~~

~~~rust
// 入口函数
fn main() {
    // 声明不可变的变量
    let a = 12;
    a = 3;	// 报错。不可变变量不能直接赋值
    let a = 3;	// 可行
    
    // 声明可变变量
    let mut b = 2;
    b = 3;	// 可行
    
    // 输出到命令行
    println!("a is {}", a);
    println!("a is {0} {1}", a, b);
    
    let s = "hello world";
    test(s[0..5]);
}

fn test(s: &str){
    println!(s);
}

struct Site {
    domain: String,
    name: String,
    nation: String,
    found: u32
}
~~~

