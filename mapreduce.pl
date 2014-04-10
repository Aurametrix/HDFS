## THIS IS ALL STILL EXPERIMENTAL!!
  ## DO NOT USE FOR PRODUCTION!!
  ## LOOK AT THE ROADMAP AND FEEDBACK WHAT YOU FIND IMPORTANT!!

  use Parallel::MapReduce;
  my $mri = new Parallel::MapReduce (MemCacheds => [ '127.0.0.1:11211', .... ],
                                     Workers    => [ '10.0.10.1', '10.0.10.2', ...]);

  my $A = {1 => 'this is something ',
           2 => 'this is something else',
           3 => 'something else completely'};

  # apply MR algorithm (word count) on $A
  my $B = $mri->mapreduce (
                             sub {
                                 my ($k, $v) = (shift, shift);
                                 return map { $_ => 1 } split /\s+/, $v;
                             },
                             sub {
                                 my ($k, $v) = (shift, shift);
                                 my $sum = 0;
                                 map { $sum += $_ } @$v;
                                 return $sum;
                             },
                             $A
                           );

  # prefabricate mapreducer
  my $string2lines = $mri->mapreducer (sub {...}, sub {...});
  # apply it
  my $B = &$string2lines ($A);

  # pipeline it with some other mapreducer
  my $pipeline = $mri->pipeline ($string2lines,
                                 $lines2wordcounts);

  # apply that
  my $B = &$pipeline ($A);
