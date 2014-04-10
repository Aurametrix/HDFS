// main function to invoke map & reduce tasks

int main(int argc, char *argv[]) {
 return HadoopPipes::runTask(
 HadoopPipes::TemplateFactory<WordCountMap, 
 WordCountReduce, void,
 WordCountReduce>());
}
