#! @Chapter Functionality of Topcom

#! @Section Functionality of Topcom: Examples 

LoadPackage( "TopcomInterface" );

#! @Example
rays := [[1,0],[0,1],[-1,-1]];
#! [ [ 1, 0 ], [ 0, 1 ], [ -1, -1 ] ]
points2nflips( rays, [], [] );
#! 3
points2placingtriang( rays, [], [] );
#! [ [ 0, 1 ], [ 1, 2 ], [ 0, 2 ] ]
points2finetriang( rays, [], [] );
#! [ [ 0, 1 ], [ 1, 2 ], [ 0, 2 ] ]
points2ntriangs( rays, [], [] );
#! 2
points2nfinetriangs( rays, [], [] );
#! 2
points2alltriangs( rays, [], [] );
#! [ [ 0, 1 ], [ 0, 2 ], [ 1, 2 ] ]
points2nalltriangs( rays, [], [] );
#! 1
points2allfinetriangs( rays, [], [] );
#! [ [ 0, 1 ], [ 0, 2 ], [ 1, 2 ] ]
points2allfinetriangs( rays, [], ["regular"] );
#! [ [ 0, 1 ], [ 0, 2 ], [ 1, 2 ] ]
points2nallfinetriangs( rays, [], [] );
#! 1
rays2 := [ [0,0,1], [1,0,1], [2,0,1], [0,1,1], [1,1,1], [2,1,1], [0,2,1], [1,2,1], [2,2,1], ];
#! [ [ 0, 0, 1 ], [ 1, 0, 1 ], [ 2, 0, 1 ], [ 0, 1, 1 ], [ 1, 1, 1 ], 
#!   [ 2, 1, 1 ], [ 0, 2, 1 ], [ 1, 2, 1 ], [ 2, 2, 1 ] ]
sample_triang2 := [ [2,1,0,5,4,3,8,7,6], [0,3,6,1,4,7,2,5,8] ];
#! [ [ 2, 1, 0, 5, 4, 3, 8, 7, 6 ], [ 0, 3, 6, 1, 4, 7, 2, 5, 8 ] ]
points2ntriangs( rays2, sample_triang2, [] );
#! 69
#! @EndExample