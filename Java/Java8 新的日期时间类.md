### Java8 新的日期时间类

| 名称            | 注释     | 备注                                       |
| ------------- | ------ | ---------------------------------------- |
| Instant       | 瞬时时间   |                                          |
| LocalDateTime | 日期和时间  | 2020-01-01 12:00:00                      |
| LocalDate     | 日期     | 2020-01-01                               |
| LocalTime     | 时间     | 12:00:00                                 |
| ZoneId        | 时区     | UTC+8                                    |
| Period        | 时间段    | Period 对应使用 LocalDate ，它们的作用范围域都是日期(年/月/日) |
| Duration      | 时间段    | Duration 对应使用 Instant，它们的作用范围域都是时间(天/时/分/秒/毫秒/纳秒) |
| ChronoUnit    | 时间单位枚举 |                                          |

> 存在部分函数编译时没问题，但是会在执行时报错。
>
> nanos: 纳秒
>
> millis: 毫秒

#### 示例

~~~java
// 获取当前日期时间
LocalDateTime localDateTime = LocalDateTime.now();
LocalDate localDate = LocalDate.now();
LocalTime localTime = LocalTime.now();
Instant instant = Instant.now();

// 创建
// 本地日期时间
LocalDateTime localDateTime1 = LocalDateTime.of(2020, 01, 01, 12,00,00);
// 本地日期
LocalDate localDate1 = LocalDate.of(2020, 1, 1);
// 本地时间
LocalTime localTime1 = LocalTime.of(12, 0, 0);
// 中央子午线处的时间
Instant instant1 = Instant.ofEpochSecond(instant.getEpochSecond());
// 一段时间
Period period = Period.of(1, 1, 1);
Duration duration = Duration.ofDays(1);
Duration duration1 = Duration.ofHours(1);

// 时区
ZoneId zoneId = ZoneId.of("UTC+8");

// 类型转换
LocalDateTime from = LocalDateTime.from(instant.atZone(zoneId));
Instant from1 = Instant.from(localDateTime1.atZone(zoneId));
LocalDate from2 = LocalDate.from(localDateTime);
YearMonth from3 = YearMonth.from(localDate);

// 获取年、月、日、时、分、秒
int year = localDateTime1.getYear();
int monthValue = localDateTime1.getMonthValue();
int dayOfMonth = localDateTime1.getDayOfMonth();
int hour = localDateTime1.getHour();
int minute = localDateTime1.getMinute();
int second = localDateTime1.getSecond();

// 获取时区
ZoneId zoneId1 = ZoneId.from(localDateTime.atZone(zoneId));

// 时区转换
ZonedDateTime zonedDateTime = localDateTime.atZone(zoneId);
LocalDateTime localDateTime2 = zonedDateTime.toLocalDateTime();

// 时间段计算
// 截止到localDate的年份
long untilYear = localDateTime1.until(localDateTime, ChronoUnit.YEARS);
// 加上一段时间
LocalDateTime plusTime = localDateTime1.plus(period);
LocalDateTime localDateTime3 = localDateTime1.withHour(10);
// 减去一段时间
LocalDateTime substractTime = localDateTime1.minus(period);
~~~





