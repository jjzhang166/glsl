#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float nrand( vec2 n ) {
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

float trunc( float x, float n ) {
  return floor(x*n)/n;
}

void main( void )
{
  vec2 pos = ( gl_FragCoord.xy / resolution.xy );

  float col = mix(0.0,0.1,pos.x);
	
  if ( pos.y > 5.0/6.0 ) {
    // straight, gamma corrected output
    vec3 linear = vec3(col);
    vec3 gamma = pow(linear, vec3(1.0/2.2));
    gl_FragColor = vec4(gamma, 1.0 );
  } else if ( pos.y > 4.0/6.0) {
    // added random noise (post gamma)
    col = pow(col, 1.0 / 2.2); // gamma
    float noise = 1.0 / 255.0 * nrand(pos + time*0.0);
    vec3 gamma = vec3(col) + vec3(noise);
    gl_FragColor = vec4(gamma, 1.0 );
  } else if (pos.y > 3.0 / 6.0) {
    // @pixelmager, dithering
    vec4 D2 = vec4( 3, 1, 0, 2 ) / 255.0 / 4.0;

    int i = int( mod( gl_FragCoord.x, 2.0 ) );
    int j = int( mod( gl_FragCoord.y, 2.0 ) );
    int idx = i + 2*j;
    float d = 0.0;
    d += (idx == 0) ? D2.x : 0.0;
    d += (idx == 1) ? D2.y : 0.0;
    d += (idx == 2) ? D2.z : 0.0;
    d += (idx == 3) ? D2.w : 0.0;

    col = pow(col, 1.0 / 2.2); // gamma
    col += 0.5 / 255.0;	
    float e = col - trunc( col, 255.0 );		
    vec3 gamma = vec3(( e > d ) ? ceil(col*255.0)/255.0 : floor(col*255.0)/255.0);
    gl_FragColor = vec4(gamma, 1.0 );
  } else if (pos.y > 2.0 / 6.0) {
    // el-cheapo color shift
    col = pow(col, 1.0 / 2.2); // gamma
    vec3 gamma = vec3(col, col + 1.0/3.0/255.0, col + 2.0/3.0/255.0);
    gl_FragColor = vec4(gamma, 1.0 );
  } else if (pos.y > 1.0 / 6.0) {
    // not fully done better color shift
    col = pow(col, 1.0 / 2.2); // gamma
    float i = fract(col*255.0);
    col = trunc(col, 255.0);
    vec3 fun = vec3(7.0 / 2.0, 7.0 / 4.0, 7.0 / 1.0);
    vec3 step2 = mod( floor(fun * i), 2.0 );
    vec3 gamma = vec3(col) + step2 * 1.0/255.0;
    gl_FragColor = vec4(gamma, 1.0 );
  } else {
    // black / white checkered to give 0.5 gamma base line
    vec3 linear = vec3(mod(gl_FragCoord.x + gl_FragCoord.y, 2.0));
    gl_FragColor = vec4(linear, 1.0 );
  }

  // right-hand side markers
  if( pos.x > 0.99) {
    vec3 outcol = vec3(mod(floor(pos.y*6.0), 2.0));
    gl_FragColor = vec4(outcol, 1.0 );
  }
}