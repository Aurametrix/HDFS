class WordCountReduce: public HadoopPipes::Reducer {
public:
 WordCountReduce(HadoopPipes::TaskContext& context){}
 void reduce(HadoopPipes::ReduceContext& context) {
 int sum = 0;
 while (context.nextValue()) {
 sum += HadoopUtils::toInt(context.getInputValue());
 }
 context.emit(context.getInputKey(), 
HadoopUtils::toString(sum));
 }
};

