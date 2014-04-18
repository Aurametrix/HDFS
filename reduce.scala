def reduce(key: Text, values: Iterator[IntWritable],
            output: OutputCollector[Text, IntWritable], reporter: Reporter) = {
  val sum = values reduceLeft ((a: Int, b: Int) => a + b)
  output collect (key, sum)
}
