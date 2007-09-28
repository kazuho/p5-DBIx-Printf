use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'DBIx::Printf',
    VERSION_FROM  => 'lib/DBIx/Printf.pm',
    PREREQ_PM     => {
        'DBI' => 0,
    },
    ABSTRACT_FROM => 'lib/DBIx/Printf.pm',
    AUTHOR        => 'Kazuho Oku',
);
