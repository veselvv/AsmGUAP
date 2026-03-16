#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1cm),
  numbering: none
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 12pt
)


#align(center)[
  #upper[ГУАП]
  #v(0.5cm)
  #upper[КАФЕДРА № 14]
  #v(2cm)
]

#grid(
  columns: (2fr),
  align(left)[
    #upper[ОТЧЕТ]\
    #upper[ЗАЩИЩЕН С ОЦЕНКОЙ]\
    #upper[]\
    #upper[ПРЕПОДАВАТЕЛЬ]
  ],
  align(center)[
    #v(0.5cm)
    #grid(
      columns: (2fr, 1fr, 2fr),
      gutter: 0.3em,
      [старший преподаватель],
      [],
      [Н.И.Синев],
      line(length: 100%),
      line(length: 100%),
      line(length: 100%),
      [должность, уч. степень, звание ],
      [подпись, дата],
      [инициалы, фамилия]
    )
  ]
)

#align(center)[
  #v(2cm)
  #upper[ОТЧЕТ О ЛАБОРАТОРНОЙ РАБОТЕ]
  #v(0.8cm)
  #text[ВЫЧИСЛЕНИЕ ДЛЯ БЕЗЗНАКОВЫХ ЦЕЛЫХ ЧИСЕЛ]
  #v(0.8cm)
  #text[по курсу:]
  #text[Программирование на языках Ассемблера]
  #v(4cm)
]

#grid(
  columns: (2fr),
  align(left)[
    #upper[РАБОТУ ВЫПОЛНИЛ]
  ],
  align(center)[
    #v(0.5cm)
    #grid(
      columns: (1fr, 1fr, 1fr, 1.5fr),
      gutter: 0.3em,
      align(left)[#upper[СТУДЕНТ гр.]],
      [1445],
      [],
      [В.В.Веселовский],
      line(length: 0%),
      line(length: 100%),
      line(length: 100%),
      line(length: 100%),
      [],
      [],
      [подпись, дата],
      [инициалы, фамилия]
    )

    #v(4cm)

    Санкт-Петербург 2026
  ]
)

#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 3cm, right: 1cm),
  numbering: none,
  footer: context {
    let p = counter(page).get().first()
    if p > 1 {
      align(center)[#p]
    }
  }
)

#set text(
  lang: "ru",
  font: "Times New Roman",
  size: 14pt
)

//Рамка для блока с кодом
#show raw: block.with(
  fill: luma(245),
  inset: 10pt,
  radius: 5pt,
  stroke: luma(200),
)

//Для таблиц - подпись сверху
#show figure.where(kind: table): set figure.caption(position: top)

= Описание задания
Вариант № 67. Вычислить значение функции для беззнаковых целых чисел:

$
Y = (2A^3 + 3B^2)/ (5C)
$

Программа должна быть реализована на ассемблере GAS (x86-64) с использованием только команд для работы с беззнаковыми числами. Необходимо обеспечить ввод данных с консоли, вывод результата (включая целую часть и остаток от деления).

= Формализация
*Условия и ограничения:*
- Входные данные: три беззнаковых целых числа $a$, $b$, $c$ (64-бита).
- Все операции выполняются с беззнаковыми числами.
- Программа выводит целую часть результата и остаток (так как выражение содержит деление).

*Используемые средства:*
- Ассемблер: GNU Assembler (GAS), синтаксис AT&T.
- Архитектура: x86-64.
- Системные вызовы: не используются напрямую, для ввода/вывода применяются функции библиотеки C (printf, scanf).
- Компиляция: `gcc -o laba1 laba1.s -no-pie`

*Ссылка на репозиторий:* [https://github.com/veselvv/AsmGUAP]

= Исходный код программы
```asm
.globl main 

.data
a: .quad 0 
b: .quad 0
c: .quad 0
input_str:  .asciz "%lld%lld%lld"
output_str: .asciz "Output value: %lld  %lld\n"
err_str: .asciz "Division by zero\n"

.section .text
main:
    pushq %rbp
    movq %rsp, %rbp 
    subq $32, %rsp
    andq $-16, %rsp
    leaq input_str(%rip), %rdi 
    movq $a, %rsi
    movq $b, %rdx
    movq $c, %rcx
    xor %eax, %eax 
    call scanf 

    movq a, %r13
    movq b, %r14
    movq c, %r15

    movq a, %rax
    mulq a
    mulq a
    movq $2, %rbx
    mulq %rbx
    movq %rax, %r13


    movq b, %rax
    mulq b
    movq $3, %rbx
    mulq %rbx
    movq %rax, %r14


    movq c, %rax
    movq $5, %rbx
    mulq %rbx
    movq %rax, %r15
    cmpq $0, %r15
    je division_error

    movq %r13, %rax
    addq %r14, %rax
    movq $0, %rdx
    divq %r15
    
    leaq  output_str(%rip), %rdi 
    movq %rax, %rsi
    xor %eax, %eax                 
    call printf 
    movq $0, %rax                   
    movq %rbp, %rsp
    popq %rbp
    ret         
   
division_error:
    leaq  err_str(%rip), %rdi
    xor %eax, %eax
    call printf
    movq $1, %rax 
    movq %rbp, %rsp
    popq %rbp
    ret         


```
= Тестирование
Для проверки корректности работы программы были выбраны три набора входных данных.

Ручной расчет для каждого набора приведен в таблице.

#figure(
table(
columns: (auto, auto, auto, auto, auto, auto),
align: center + horizon,
table.hline(),
[№], [*a*], [*b*], [*c*], [Ожидаемый результат], [Остаток],
table.hline(),
[1], [10], [3], [2], [$ (2*10^3 + 3*3^2)/(5*2)=(2000+27)/10 = 202$], [7],
[2], [8], [2], [1], [$ (2*8^3 + 3*2^2)/(5*1)=(1024+12)/5 = 207 $], [1],
[3], [15], [5], [3], [$ (2*15^3 + 3*5^2)/(5*3)=(6750+75)/15 = 455 $], [0],
table.hline(),
),
caption: [Тестовые наборы данных и ожидаемые результаты],
)

Результаты выполнения программы:

#figure(
image("output_test1.png", width: 80%),
caption: [Результаты програмного тестирования],
)


Анализ результатов: Программа выводит значения, полностью совпадающие с ожидаемыми в ходе ручного расчета.

= Выводы
В ходе выполнения лабораторной работы была разработана программа на языке ассемблера GAS (x86-64) для вычисления заданного выражения с беззнаковыми целыми числами. Программа обеспечивает ввод исходных данных с консоли, корректное выполнение арифметических операций (включая умножение и деление) и вывод результата вместе с остатком.

Были учтены все ограничения, накладываемые типом данных (беззнаковые числа). Реализована обработка ошибочных ситуаций. Проведено тестирование на трех различных наборах данных, результаты которого полностью совпали с расчетами, выполненными вручную.

Таким образом, можно сделать вывод, что лабораторная работа выполнена в полном объеме, все поставленные цели достигнуты, программа работает корректно и соответствует предъявляемым требованиям.