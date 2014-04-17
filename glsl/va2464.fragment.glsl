// moskewcz@alumni.princeton.edu : 2012.05.11 : modified to noise-sorter to further demo state via backbuffer

// TV Noise, https://twitter.com/#!/baldand/status/159884748855058433
// Originally designed to fit in a tweet with just a bit of boilerplate. 
// (Don't set higher res than 2 or it spoils the effect!)


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 sbb( vec2 sp ) { return texture2D(backbuffer,sp/resolution.xy); }

void main( void ) {
	if( gl_FragCoord.x < 5.0 )
	{
	  vec2 u = ( gl_FragCoord.xy / resolution.xy );
	  float w,x,y,z=0.0;vec3 c;
	  u+=vec2(20.,11.+fract(time));y=fract(u.x*u.x*u.y);c=vec3(float(int(y+.5)));
	  gl_FragColor = vec4(c,1.);
	}
	else
	{
          
          vec2 sp = gl_FragCoord.xy;
	  sp.x -= sin(sp.x * sin(time * sp.y * 5.0));
	  //vec2 np = ( sp / resolution.xy );
	  //vec4 nc = sbb(np);
          if( sp.x > 0.0 )
          {
             int y = int(sp.y+.5);
             int x = int(sp.x+.5);
             bool nc = false;
             bool up = sbb( sp + vec2(-1,1) )[0] > .5;
		  if( y == 0 ) { up = false; }
	     bool cur = sbb( sp + vec2(-1,0) )[0] > .5;
             bool down = sbb( sp + vec2(-1,-1) )[0] > .5;
             bool xe = x / 2 * 2 == x;
             bool ye = y / 2 * 2 == y;
             
	      
             if( ye == xe ) { nc = cur && down; }
             else { nc = cur || up; }
	     
             
	     if( nc ) { gl_FragColor = vec4(1,1,1,1); } 
             else {   gl_FragColor = vec4(0,0,0,0); }
	  }
	  else
	  {
	      gl_FragColor = sbb(sp + vec2(-1,0));	  
	  }
	}
}