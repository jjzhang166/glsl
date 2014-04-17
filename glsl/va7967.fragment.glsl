
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float ease( float x ) { return x * x * (3.0 - 2.0 * x); }  
vec2 ease( vec2 x ) { return x * x * (3.0 - 2.0 * x); }
vec3 ease( vec3 x ) { return x * x * (3.0 - 2.0 * x); }
vec4 ease( vec4 x ) { return x * x * (3.0 - 2.0 * x); }

//
//  FAST32_hash
//  A very fast hashing function.  Requires 32bit support.
//  http://briansharpe.wordpress.com/2011/11/15/a-fast-and-simple-32bit-floating-point-hash-function/
//
//  The hash formula takes the form....
//  hash = mod( coord.x * coord.x * coord.y * coord.y, SOMELARGEFLOAT ) / SOMELARGEFLOAT
//  We truncate and offset the domain to the most interesting part of the noise.
//  SOMELARGEFLOAT should be in the range of 400.0->1000.0 and needs to be hand picked.  Only some give good results.
//  3D Noise is achieved by offsetting the SOMELARGEFLOAT value by the Z coordinate
//
vec4 FAST32_hash_2D( vec2 gridcell )  //  generates a random number for each of the 4 cell corners
{
  //  gridcell is assumed to be an integer coordinate
  const vec2 OFFSET = vec2( 26.0, 161.0 );
  const float DOMAIN = 71.0;
  const float SOMELARGEFLOAT = 951.135664;
  vec4 P = vec4( gridcell.xy, gridcell.xy + 1.0 );
  P = P - floor(P * ( 1.0 / DOMAIN )) * DOMAIN; //  truncate the domain
  P += OFFSET.xyxy;               //  offset to interesting part of the noise
  P *= P;                     //  calculate and return the hash
  return fract( P.xzxz * P.yyww * ( 1.0 / SOMELARGEFLOAT ) );
}
void FAST32_hash_2D( vec2 gridcell, out vec4 hash_0, out vec4 hash_1 )  //  generates 2 random numbers for each of the 4 cell corners
{
  //    gridcell is assumed to be an integer coordinate
  const vec2 OFFSET = vec2( 26.0, 161.0 );
  const float DOMAIN = 71.0;
  const vec2 SOMELARGEFLOATS = vec2( 951.135664, 642.949883 );
  vec4 P = vec4( gridcell.xy, gridcell.xy + 1.0 );
  P = P - floor(P * ( 1.0 / DOMAIN )) * DOMAIN;
  P += OFFSET.xyxy;
  P *= P;
  P = P.xzxz * P.yyww;
  hash_0 = fract( P * ( 1.0 / SOMELARGEFLOATS.x ) );
  hash_1 = fract( P * ( 1.0 / SOMELARGEFLOATS.y ) );
}
void FAST32_hash_2D(  vec2 gridcell,
            out vec4 hash_0,
            out vec4 hash_1,
            out vec4 hash_2 ) //  generates 3 random numbers for each of the 4 cell corners
{
  //    gridcell is assumed to be an integer coordinate
  const vec2 OFFSET = vec2( 26.0, 161.0 );
  const float DOMAIN = 71.0;
  const vec3 SOMELARGEFLOATS = vec3( 951.135664, 642.949883, 803.202459 );
  vec4 P = vec4( gridcell.xy, gridcell.xy + 1.0 );
  P = P - floor(P * ( 1.0 / DOMAIN )) * DOMAIN;
  P += OFFSET.xyxy;
  P *= P;
  P = P.xzxz * P.yyww;
  hash_0 = fract( P * ( 1.0 / SOMELARGEFLOATS.x ) );
  hash_1 = fract( P * ( 1.0 / SOMELARGEFLOATS.y ) );
  hash_2 = fract( P * ( 1.0 / SOMELARGEFLOATS.z ) );
}

//
//  Value Noise 2D
//  Return value range of 0.0->1.0
//  http://briansharpe.files.wordpress.com/2011/11/valuesample1.jpg
//
float Value2D( vec2 P )
{
  //  establish our grid cell and unit position
  vec2 Pi = floor(P);
  vec2 Pf = P - Pi;

  //  calculate the hash.
  //  ( various hashing methods listed in order of speed )
  vec4 hash = FAST32_hash_2D( Pi );
  //vec4 hash = BBS_hash_2D( Pi );
  //vec4 hash = SGPP_hash_2D( Pi );
  //vec4 hash = BBS_hash_hq_2D( Pi );

  //  blend the results and return
  vec2 blend = ease( Pf );
  vec2 res0 = mix( hash.xy, hash.zw, blend.y );
  return mix( res0.x, res0.y, blend.x );
}


//
//  Perlin Noise 2D  ( gradient noise )
//  Return value range of -1.0->1.0
//  http://briansharpe.files.wordpress.com/2011/11/perlinsample.jpg
//
float Perlin2D( vec2 P )
{
  //  establish our grid cell and unit position
  vec2 Pi = floor(P);
  vec4 Pf_Pfmin1 = P.xyxy - vec4( Pi, Pi + 1.0 );

#if 1
  //
  //  classic noise looks much better than improved noise in 2D, and with an efficent hash function runs at about the same speed.
  //  requires 2 random numbers per point.
  //

  //  calculate the hash.
  //  ( various hashing methods listed in order of speed )
  vec4 hash_x, hash_y;
  FAST32_hash_2D( Pi, hash_x, hash_y );
  //SGPP_hash_2D( Pi, hash_x, hash_y );

  //  calculate the gradient results
  vec4 grad_x = hash_x - 0.49999;
  vec4 grad_y = hash_y - 0.49999;
  vec4 grad_results = inversesqrt( grad_x * grad_x + grad_y * grad_y ) * ( grad_x * Pf_Pfmin1.xzxz + grad_y * Pf_Pfmin1.yyww );

#if 1
  //  Classic Perlin Interpolation
  grad_results *= 1.4142135623730950488016887242097;    //  (optionally) scale things to a strict -1.0->1.0 range    *= 1.0/sqrt(0.5)
  vec2 blend = ease( Pf_Pfmin1.xy );
  vec2 res0 = mix( grad_results.xy, grad_results.zw, blend.y );
  return mix( res0.x, res0.y, blend.x );
#else
  //  Classic Perlin Surflet
  //  http://briansharpe.wordpress.com/2012/03/09/modifications-to-classic-perlin-noise/
  grad_results *= 2.3703703703703703703703703703704;    //  (optionally) scale things to a strict -1.0->1.0 range    *= 1.0/cube(0.75)
  vec4 vecs_len_sq = Pf_Pfmin1 * Pf_Pfmin1;
  vecs_len_sq = vecs_len_sq.xzxz + vecs_len_sq.yyww;
  return dot( Falloff_Xsq_C2( min( vec4( 1.0 ), vecs_len_sq ) ), grad_results );
#endif

#else
  //
  //  2D improved perlin noise.
  //  requires 1 random value per point.
  //  does not look as good as classic in 2D due to only a small number of possible cell types.  But can run a lot faster than classic perlin noise if the hash function is slow
  //

  //  calculate the hash.
  //  ( various hashing methods listed in order of speed )
  vec4 hash = FAST32_hash_2D( Pi );
  //vec4 hash = BBS_hash_2D( Pi );
  //vec4 hash = SGPP_hash_2D( Pi );
  //vec4 hash = BBS_hash_hq_2D( Pi );

  //
  //  evaulate the gradients
  //  choose between the 4 diagonal gradients.  ( slightly slower than choosing the axis gradients, but shows less grid artifacts )
  //  NOTE:  diagonals give us a nice strict -1.0->1.0 range without additional scaling
  //  [1.0,1.0] [-1.0,1.0] [1.0,-1.0] [-1.0,-1.0]
  //
  hash -= 0.5;
  vec4 grad_results = Pf_Pfmin1.xzxz * sign( hash ) + Pf_Pfmin1.yyww * sign( abs( hash ) - 0.25 );

  //  blend the results and return
  vec2 blend = Interpolation_C2( Pf_Pfmin1.xy );
  vec2 res0 = mix( grad_results.xy, grad_results.zw, blend.y );
  return mix( res0.x, res0.y, blend.x );

#endif
}

//
//  SimplexPerlin2D  ( simplex gradient noise )
//  Perlin noise over a simplex (triangular) grid
//  Return value range of -1.0->1.0
//  http://briansharpe.files.wordpress.com/2012/01/simplexperlinsample.jpg
//
//  Implementation originally based off Stefan Gustavson's and Ian McEwan's work at...
//  http://github.com/ashima/webgl-noise
//
float SimplexPerlin2D( vec2 P )
{
  //  simplex math constants
  const float SKEWFACTOR = 0.36602540378443864676372317075294;      // 0.5*(sqrt(3.0)-1.0)
  const float UNSKEWFACTOR = 0.21132486540518711774542560974902;      // (3.0-sqrt(3.0))/6.0
  const float SIMPLEX_TRI_HEIGHT = 0.70710678118654752440084436210485;  // sqrt( 0.5 )  height of simplex triangle
  const vec3 SIMPLEX_POINTS = vec3( 1.0-UNSKEWFACTOR, -UNSKEWFACTOR, 1.0-2.0*UNSKEWFACTOR );    //  vertex info for simplex triangle

  //  establish our grid cell.
  P *= SIMPLEX_TRI_HEIGHT;    // scale space so we can have an approx feature size of 1.0  ( optional )
  vec2 Pi = floor( P + dot( P, vec2( SKEWFACTOR ) ) );

  //  calculate the hash.
  //  ( various hashing methods listed in order of speed )
  vec4 hash_x, hash_y;
  FAST32_hash_2D( Pi, hash_x, hash_y );
  //SGPP_hash_2D( Pi, hash_x, hash_y );

  //  establish vectors to the 3 corners of our simplex triangle
  vec2 v0 = Pi - dot( Pi, vec2( UNSKEWFACTOR ) ) - P;
  vec4 v1pos_v1hash = (v0.x < v0.y) ? vec4(SIMPLEX_POINTS.xy, hash_x.y, hash_y.y) : vec4(SIMPLEX_POINTS.yx, hash_x.z, hash_y.z);
  vec4 v12 = vec4( v1pos_v1hash.xy, SIMPLEX_POINTS.zz ) + v0.xyxy;

  //  calculate the dotproduct of our 3 corner vectors with 3 random normalized vectors
  vec3 grad_x = vec3( hash_x.x, v1pos_v1hash.z, hash_x.w ) - 0.49999;
  vec3 grad_y = vec3( hash_y.x, v1pos_v1hash.w, hash_y.w ) - 0.49999;
  vec3 grad_results = inversesqrt( grad_x * grad_x + grad_y * grad_y ) * ( grad_x * vec3( v0.x, v12.xz ) + grad_y * vec3( v0.y, v12.yw ) );

  //  Normalization factor to scale the final result to a strict 1.0->-1.0 range
  //  x = ( sqrt( 0.5 )/sqrt( 0.75 ) ) * 0.5
  //  NF = 1.0 / ( x * ( ( 0.5  x*x ) ^ 4 ) * 2.0 )
  //  http://briansharpe.wordpress.com/2012/01/13/simplex-noise/#comment-36
  const float FINAL_NORMALIZATION = 99.204334582718712976990005025589;

  //  evaluate the surflet, sum and return
  vec3 m = vec3( v0.x, v12.xz ) * vec3( v0.x, v12.xz ) + vec3( v0.y, v12.yw ) * vec3( v0.y, v12.yw );
  m = max(0.5 - m, 0.0);    //  The 0.5 here is SIMPLEX_TRI_HEIGHT^2
  m = m*m;
  m = m*m;
  return dot(m, grad_results) * FINAL_NORMALIZATION;
}


float noise(vec2 s, vec2 v)
{
  float c;
	
  if (s.y < 0.33)
    c = SimplexPerlin2D(v);
  else if (s.y < 0.66)
    c = Perlin2D(v);
  else
    c = 2.0*Value2D(v)-1.0;

  return c;
}

const float F_SCALE = 30.0;


float fbm(vec2 s, vec2 v)
{
  float f = 0.0;
  vec2 p = v + time;
 
  f  = 0.571429*noise(s, p); 
  f += 0.285714*noise(s, p*2.0); 
  f += 0.142857*noise(s, p*4.0);
  
  return f;
}

float turb(vec2 s, vec2 v)
{
  float f = 0.0;
  vec2 p = v + time;
 
  f  = abs(0.571429*noise(s, p)); 
  f += abs(0.285714*noise(s, p*2.0)); 
  f += abs(0.142857*noise(s, p*4.0));
  
  return f;
}

void main(void)
{
  vec2  uv = gl_FragCoord.xy/resolution.xy;
  float c;

  if (uv.x < 0.33)
    c = 0.5*(noise(uv, uv*F_SCALE + 0.25*time)+1.0);
  else if (uv.x < 0.66)
    c = 0.5*(fbm(uv, uv*F_SCALE + 0.25*time)+1.0);
  else
    c = turb(uv, uv*F_SCALE + 0.25*time);


  gl_FragColor.rgb = vec3(c,c,c);
}
