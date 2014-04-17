#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// Cmen.
// Backpassmassages/.

void main( void ) {

	vec2 position = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy ); position.x *= resolution.x/resolution.y;
//	position.x *= pow(position.x,1.0+(sin(time))*1.0001); 
  	
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 70.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 40.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

  	vec4 thisCol = vec4(
          texture2D(backbuffer, vec2(gl_FragCoord.x + sin(time) * 0.1, position.x + sin(time*0.6) * 0.2)).r * 0.6,
          texture2D(backbuffer, gl_FragCoord.xy + sin(time * 0.5 * position.y * 4.1) * 0.1).g * 0.8,
          texture2D(backbuffer, gl_FragCoord.xy + sin(time * 0.6 * position.x * 4.4) * 0.1).b * 0.5,
          texture2D(backbuffer, gl_FragCoord.xy).a
          );

  	vec4 newCol =  vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
  	newCol *= vec4(vec3(sin(length(position * 16.) + time * 8.0)),1.0);
  	gl_FragColor = newCol;

  	//vec4 mixBiz = vec4(vec3(newCol.xyz * (thisCol.xyz *0.2)),1.0);
	//gl_FragColor = mixBiz;
  	gl_FragColor = mix(gl_FragColor, vec4(1.0), thisCol );
}