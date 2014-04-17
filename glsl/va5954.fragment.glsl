#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D textureSampler;
uniform vec2 texcoordOffset;
uniform vec3 target;
//uniform vec3 speed;


void main(void) {
 
 vec2 t = gl_FragCoord.xy / resolution.xy;
 vec4 vertColor = texture2D( textureSampler, texcoordOffset );
	
	vec3 speed=vec3(0.1, 0.1, 0.1);
	
 vec4 col;
 col.r=vertColor.r+(target.r-vertColor.r)*speed.r;
 col.g=vertColor.g+(target.g-vertColor.g)*speed.g;
 col.b=vertColor.b+(target.b-vertColor.b)*speed.b;
	
  gl_FragColor = col;
  //gl_FragColor = vec4(1, 0.5, 0.2, 1);
}