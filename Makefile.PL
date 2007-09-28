use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'DBI::Printf',
    VERSION_FROM  => 'lib/DBI/Printf.pm',
    PREREQ_PM     => {
        'DBI' => 0,
    },
    ABSTRACT_FROM => 'lib/DBI/Printf.pm',
    AUTHOR        => 'Kazuho Oku',
);
