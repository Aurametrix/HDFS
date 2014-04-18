def map(key: LongWritable, value: Text,
         output: OutputCollector[Text, IntWritable], reporter: Reporter) =
  (value split " ") foreach (output collect (_, one))
