```java
@Test
void Test() {

    //region 创建 Stream
    // List 转 Stream
    List<Integer> list = new ArrayList<Integer>() {{
        add(1);
    }};
    Stream<Integer> stream = list.stream(); //获取一个顺序流
    Stream<Integer> parallelStream = list.parallelStream(); //获取一个并行流

    // Arrays 转 Stream
    String[] strings = new String[]{"1"};
    Stream<String> stream1 = Arrays.stream(strings);

    // ArrayList 转 Stream
    ArrayList<String> arrayList = new ArrayList<String>() {{
        add("1");
    }};
    Stream<String> stream2 = arrayList.stream();

    // of 创建 Stream
    Stream<Integer> stream4 = Stream.of(1, 2, 3, 4, 5, 6);

    // iterate 创建 Stream
    Stream<Integer> stream3 = Stream.iterate(0, item -> item + 1).limit(1000);

    // generate 创建 Stream
    Stream<Double> stream5 = Stream.generate(Math::random);

    // BufferedReader 创建 Stream
    try {
        FileReader fileReader = new FileReader("D:/test.txt");
        Stream<String> stream6 = new BufferedReader(fileReader).lines();
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }


    // Pattern 创建 Stream
    Pattern compile = Pattern.compile(",");
    Stream<String> stream7 = compile.splitAsStream("1,2,3,4,5,");

    // 创建并行流
    Stream<Integer> stringStream = stream.parallel();
    //endregion

    // filter, limit, skip, distinct
    Stream<Integer> stream8 = stream
            .filter(p -> p > 1)
            .limit(10)
            .skip(3)
            .distinct()
            .sorted();

    // map, reduce
    Optional<Integer> reduce = stream2
            .map((Integer::parseInt))
            .reduce(Math::addExact);

    // peek 遍历要素，进行修改
    Student s1 = new Student("aa", 10);
    Student s2 = new Student("bb", 20);
    List<Student> studentList = Arrays.asList(s1, s2);
    studentList.stream()
            .peek(o -> o.setAge(100))
            .forEach(System.out::println);


}

@Test
void Test2() {
    // 匹配聚合操作
    // allMatch：接收一个 Predicate 函数，当流中每个元素都符合该断言时才返回true
    // noneMatch：接收一个 Predicate 函数，当流中每个元素都不符合该断言时才返回true
    // anyMatch：接收一个 Predicate 函数，只要流中有一个元素满足该断言则返回true
    // findFirst：返回流中第一个元素
    // findAny：返回流中的任意元素
    // count：返回流中元素的总个数
    // max：返回流中元素最大值
    // min：返回流中元素最小值

    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);

    boolean allMatch = list.stream().allMatch(e -> e > 10); //false
    boolean noneMatch = list.stream().noneMatch(e -> e > 10); //true
    boolean anyMatch = list.stream().anyMatch(e -> e > 4);  //true

    Integer findFirst = list.stream().findFirst().get(); //1
    Integer findAny = list.stream().findAny().get(); //1

    long count = list.stream().count(); //5
    Integer max = list.stream().max(Integer::compareTo).get(); //5
    Integer min = list.stream().min(Integer::compareTo).get(); //1
}

@Test
void Test3() {
    // collect：接收一个Collector实例，将流中元素收集成另外一个数据结构
    Student s1 = new Student("aa", 10, 1);
    Student s2 = new Student("bb", 20, 2);
    Student s3 = new Student("cc", 10, 3);
    List<Student> list = Arrays.asList(s1, s2, s3);

    //装成list
    List<Integer> ageList = list.stream().map(Student::getAge).collect(Collectors.toList()); // [10, 20, 10]

    //转成set
    Set<Integer> ageSet = list.stream().map(Student::getAge).collect(Collectors.toSet()); // [20, 10]

    //转成map,注:key不能相同，否则报错
    Map<String, Integer> studentMap = list.stream().collect(Collectors.toMap(Student::getName, Student::getAge)); // {cc=10, bb=20, aa=10}

    //字符串分隔符连接
    String joinName = list.stream().map(Student::getName).collect(Collectors.joining(",", "(", ")")); // (aa,bb,cc)

    //聚合操作
    //1.学生总数
    Long count = list.stream().collect(Collectors.counting()); // 3
    //2.最大年龄 (最小的minBy同理)
    Integer maxAge = list.stream().map(Student::getAge).collect(Collectors.maxBy(Integer::compare)).get(); // 20
    //3.所有人的年龄
    Integer sumAge = list.stream().collect(Collectors.summingInt(Student::getAge)); // 40
    //4.平均年龄
    Double averageAge = list.stream().collect(Collectors.averagingDouble(Student::getAge)); // 13.333333333333334
    // 带上以上所有方法
    DoubleSummaryStatistics statistics = list.stream().collect(Collectors.summarizingDouble(Student::getAge));
    System.out.println("count:" + statistics.getCount() + ",max:" + statistics.getMax() + ",sum:" + statistics.getSum() + ",average:" + statistics.getAverage());

    //分组
    Map<Integer, List<Student>> ageMap = list.stream().collect(Collectors.groupingBy(Student::getAge));
    //多重分组,先根据类型分再根据年龄分
    Map<Integer, Map<Integer, List<Student>>> typeAgeMap = list.stream().collect(Collectors.groupingBy(Student::getType, Collectors.groupingBy(Student::getAge)));

    //分区
    //分成两部分，一部分大于10岁，一部分小于等于10岁
    Map<Boolean, List<Student>> partMap = list.stream().collect(Collectors.partitioningBy(v -> v.getAge() > 10));

    //规约
    Integer allAge = list.stream().map(Student::getAge).collect(Collectors.reducing(Integer::sum)).get(); //40
}
```