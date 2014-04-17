#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// see http://www.opengl.org/registry/specs/ARB/framebuffer_sRGB.txt

vec3 srgb2lin( vec3 cs )
{
	vec3 c_lo = cs / 12.92;
	vec3 c_hi = pow( (cs + 0.055) / 1.055, vec3(2.4) );
	vec3 t = step( vec3(0.04045), cs );
	return mix( c_lo, c_hi, t );
}

vec3 lin2srgb( vec3 cl )
{
	cl = clamp( cl, 0.0, 1.0 );
	vec3 c_lo = 12.92 * cl;
	vec3 c_hi = 1.055 * pow(cl,vec3(0.41666)) - 0.055;
	vec3 t = step( vec3(0.0031308), cl );
	return mix( c_lo, c_hi, t );
}


void main( void )
{
  vec2 pos = ( gl_FragCoord.xy / resolution.xy );

  float col = 0.125 * pos.x;
	
  if ( pos.y > 4.0/6.0 )
  {
	vec3 linear = vec3(col);
	gl_FragColor = vec4(linear, 1.0 );
  }
  else if ( pos.y > 2.0/6.0 )
  {
    vec3 linear = vec3(col);
    vec3 gamma = srgb2lin( lin2srgb( linear ) );
    gl_FragColor = vec4(gamma, 1.0 );	  

  }
  else if ( pos.y > 0.0 )
  {
    vec3 linear = vec3(col);
    vec3 gamma = lin2srgb( linear );
    gl_FragColor = vec4(gamma, 1.0 );
  }

  // right-hand side markers
  if( pos.x > 0.99) {
    vec3 outcol = vec3(mod(floor(pos.y*3.0), 2.0));
    gl_FragColor = vec4(outcol, 1.0 );
  }
}