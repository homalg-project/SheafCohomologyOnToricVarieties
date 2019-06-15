################################################################################################
##
##  BlowupsOfToricVarieties.gd          ToricVarieties package
##
##  Copyright 2019                      Martin Bies,       ULB Brussels
##
#! @Chapter Blowups of toric varieties
##
################################################################################################

########################
##
## Constructors
##
########################

InstallMethod( BlowupOfToricVariety,
               "for a toric variety and a string specifying the blowup locus",
               [ IsToricVariety, IsList, IsString ],
  function( variety, blowup_locus, blowup_variable )
    local rays, blowup_vars, indices, indeterminates, blowup_rays,
         blowup_cone, rays_in_max_cones, max_cones, i, j, k, rays_of_cone,
         max_supercones, extended_cone_list, smooth_list, extended_ray_list,
         new_cones, u_pos, r_list, partitions, w, weight;
    
    # 0: test if blow_up locus is given as valid input
    if not IsString( blowup_locus ) then
        Error( "The blowup locus must be specified as a string" );
    fi;
    blowup_vars := SplitString( blowup_locus, "," );
    rays := RayGenerators( FanOfVariety( variety ) );
    if Length( blowup_vars ) < 2 then
        Error( "Invalid blowup locus" );
    fi;
    if Length( blowup_vars ) > Length( rays )then
        Error( "Invalid blowup locus" );
    fi;
    
    # 1: identify the ray generators, which form the cone tau used for this blowup
    indeterminates := IndeterminatesOfPolynomialRing( CoxRing( variety ) );
    indeterminates := List( [ 1 .. Length( indeterminates ) ], i -> String( indeterminates[ i ] ) );
    indices := List( [ 1 .. Length( blowup_vars ) ], i -> Position( indeterminates, blowup_vars[ i ] ) );
    blowup_rays := List( [ 1 .. Length( blowup_vars ) ],
                                          i -> rays[ Position( indeterminates, blowup_vars[ i ] ) ] );
    
    # 1: test that blowup_variable is not yet used for the other toric variables
    if Position( indeterminates, blowup_variable ) <> fail then
        Error( Concatenation( "Homogeneous coordinate associated to blowup must differ",
                              "from all other homogeneous coordinates" ) );
    fi;
    
    # 2: is the cone generated by blowup_rays contained in the fan?
    # 2: to this end find all max cones which contain this cone and verify that there is at least one
    # 2: check that all of these are smooth, for then also their faces etc. are smooth
    # 2: if this is passed, the conditions for theorem 3.3.17 in CLS are satisfied and we can proceed
    
    # 2.1 find all max cones which contain the cone in question
    blowup_cone := Cone( blowup_rays );
    rays_in_max_cones := RaysInMaximalCones( FanOfVariety( variety ) );
    max_cones := List( [ 1 .. Length( rays_in_max_cones ) ],
                        i -> Cone( List( [ 1 .. Length( rays_in_max_cones[ i ] ) ],
                                                     k -> rays_in_max_cones[ i ][ k ] * rays[ k ] ) ) );
    
    max_supercones := [];
    extended_cone_list := [];
    smooth_list := [];
    for i in [ 1 .. Length( max_cones ) ] do
    
        rays_of_cone := RayGenerators( max_cones[ i ] );
        if Contains( max_cones[ i ], blowup_cone ) then
            Add( smooth_list, IsSmooth( max_cones[ i ] ) );
            Add( max_supercones, List( [ 1 .. Length( rays_of_cone ) ],
                                                           i -> Position( rays, rays_of_cone[ i ] ) ) );
        else
            Add( extended_cone_list, List( [ 1 .. Length( rays_of_cone ) ],
                                                           i -> Position( rays, rays_of_cone[ i ] ) ) );
        fi;
    od;
    
    # 2.2 check that there is at least one max cone containing the one provided in the input
    if Length( max_supercones ) = 0 then
        Error( "Blowup locus must be contained in at least one maximal cone" );
    fi;
    
    # 2.3 check that all max_supercones are smooth
    if ( Length( DuplicateFreeList( smooth_list ) ) > 1 ) or ( smooth_list[ 1 ] = false ) then
        Error( "At least one maximal cone which contains the blowup locus is not smooth" );
    fi;
    
    # 3: extend the ray list
    # 3: extend the ray list
    # 3: extend the ray list
    # 3: extend the ray list
    extended_ray_list := Concatenation( rays, [ Sum( blowup_rays ) ] );
    
    # 4: identify the new cones
    # 4: identify the new cones
    # 4: identify the new cones
    # 4: identify the new cones
    new_cones := [];
    u_pos := Length( extended_ray_list );
    for i in [ 1 .. Length( max_supercones ) ] do
    
        # update the ray_list with the sum of the blowup rays
        r_list := Concatenation( max_supercones[ i ], [ u_pos ] );
    
        # next find all partitions which can create maximal cones of interest for us
        partitions := Combinations( r_list, Length( max_supercones[ i ] ) );
    
        # we have to exclude all elements in partitions, which contain all blowup rays
        for j in [ 1 .. Length( partitions ) ] do
    
            # check if at least one ray generator is not contained in this partition
            k := 1;
            while k < Length( blowup_rays ) + 1 do
    
                if Position( partitions[ j ], Position( rays, blowup_rays[ k ] ) ) = fail then
                    Add( extended_cone_list, partitions[ j ] );
                    k := Length( blowup_rays ) + 1;
                fi;
    
                k := k + 1;
    
            od;
    
        od;
    
    od;
    
    # 5: create the new toric variety
    # 5: create the new toric variety
    # 5: create the new toric variety
    # 5: create the new toric variety
    
    # set the new grading of the Cox ring
    w := WeightsOfIndeterminates( CoxRing( variety ) );
    w := List( [ 1 .. Length( w ) ], i -> EvalString( String( w[ i ] ) ) );
    if not IsList( w[ 1 ] ) then
        w := List( [ 1 .. Length( w ) ], i -> [ w[ i ] ] );
    fi;
    for i in [ 1 .. Length( w ) ] do
    
        if Position( indices, i ) <> fail then
            w[ i ] := Concatenation( w[ i ], [ 1 ] );
        else
            w[ i ] := Concatenation( w[ i ], [ 0 ] );
        fi;
    
    od;
    weight := List( [ 1 .. Length( w[ 1 ] ) ], i -> 0 );
    weight[ Length( weight ) ] := -1;
    w := Concatenation( w, [ weight ] );
    
    # extend the variables accordingly
    indeterminates := Concatenation( indeterminates, [ blowup_variable ] );
    indeterminates := JoinStringsWithSeparator( indeterminates, "," );
    
    # and construct the new variety from extended_ray_list, extended_cone_list, 
    # the gradings of the Cox ring and the names of the indeterminates of the Cox ring
    return ToricVariety( extended_ray_list, extended_cone_list, w, indeterminates );
    
end );


InstallMethod( SequenceOfBlowupsOfToricVariety,
               "for a toric variety and a list",
               [ IsToricVariety, IsList ],
  function( variety, blowup_sequence )
    local i, blowup_space;
    
    # if no blowup is to be performed
    if Length( blowup_sequence ) = 0 then
        return variety;
    fi;
    
    # otherwise iterate over the blowups
    blowup_space := variety;
    for i in [ 1 .. Length( blowup_sequence ) ] do
        if not Length( blowup_sequence[ i ] ) = 2 then
            Error( Concatenation( "The information for blowup ", String( i ), " is corrupted" ) );
        fi;
        
        blowup_space := BlowupOfToricVariety( blowup_space, 
                                              blowup_sequence[ i ][ 1 ], blowup_sequence[ i ][ 2 ] );

    od;
    
    # and finally return the result
    return blowup_space;

end );
