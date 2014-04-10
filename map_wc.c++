class WordCountMap: public HadoopPipes::Mapper {
public:
 WordCountMap(HadoopPipes::TaskContext& context){}
 void map(HadoopPipes::MapContext& context) {
 std::vector<std::string> words = 
 HadoopUtils::splitString(context.getInputValue(), " ");
 for(unsigned int i=0; i < words.size(); ++i) {
 context.emit(words[i], "1");
 }}};
