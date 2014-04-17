
#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float udRoundBox( vec3 p, vec3 b, float r )
{
	return length(max(abs(p)-b,0.0))-r;
}

float distaceFunction(vec3 pos)
{
  return length(pos) - 1.0;
}

void main( void ) {
 
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
 	vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
	vec3 camPos = vec3(0.0, 0.0, 3.0);
  	vec3 camDir = vec3(0.0, 0.0, -1.0);
  	vec3 camUp = vec3(0.0, 1.0, 0.0);
  	vec3 camSide = cross(camDir, camUp);
  	float focus = 1.8;
	
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;
 
	//color = udRoundBox( camPos, camDir, color );
	
	//gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
	
	  vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
	 
	  float t = 0.0, d;
	  vec3 posOnRay = camPos;
	 
	  for(int i=0; i<16; ++i)
	  {
	    d = distaceFunction(posOnRay);
	    t += d;
	    posOnRay = camPos + t*rayDir;
	  }
	 
	  if(abs(d) < 0.001)
	  {
		color = udRoundBox( camPos, camDir, color );
	    gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 ); //gl_FragColor = vec4(1.0);
	  }
	else
	  {
	    gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 ); //gl_FragColor = vec4(0.0);
	  }
 
}