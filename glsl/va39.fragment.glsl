#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

// Quick test of using backbuffer 

void main(){
  vec2 pos = gl_FragCoord.xy / resolution;
  vec2 oldpos = pos +  sin(5. * time); // nearbyish

  vec4 lastPixel = texture2D(backbuffer, oldpos );
  vec4 lastPixel2 = texture2D(backbuffer, pos );
  vec4 mixedPixel = mix(lastPixel, lastPixel2, .9);

	vec3 myCol = vec3(0.0);
  myCol.r = cos(5. * time * pos.y) + (mouse - pos).y;
  myCol.g = sin(2. * time * pos.x) * sin(mouse.x) - (pos - mouse).x;
  myCol.b = sin(time * time * pos.x - myCol.g) * cos(mouse.y);
	
	
  gl_FragColor = vec4( mix(mixedPixel.rgb, myCol.rgb, 0.75), 1.0 );

}