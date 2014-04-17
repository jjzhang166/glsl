// This one would totally profit from backbuffer LINEAR interpolation

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

uniform sampler2D backbuffer;

float border(vec2 uv, float thickness){
	uv = fract(uv - vec2(0.5));
	uv = min(uv, vec2(1.)-uv)*2.;
	return clamp(max(uv.x,uv.y)-1.+thickness,0.,1.)/thickness;;
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	gl_FragColor = vec4(border(0.5 + (uv - 0.5)*vec2(resolution.x/resolution.y,1.)*12., 1.0) < 0.15 );

        vec4 col = vec4(texture2D( backbuffer, mouse  + (sin(uv.yx*10.0+time*1234.5)+cos(uv.xy*10.0+time*3125.4))*0.002 + (uv-mouse)*0.95 ).r - 0.03,
          texture2D( backbuffer, mouse  + (sin(uv.yx*10.0+time*1232.5)+cos(uv.xy*10.0+time*3125.4))*0.002 + (uv-mouse)*0.95 ).g - 0.03,
          texture2D( backbuffer, mouse  + (sin(uv.yx*10.0+time*1231.5)+cos(uv.xy*10.0+time*3123.14))*0.002 + (uv-mouse)*0.95 ).b - 0.03,
          texture2D( backbuffer, mouse  + (sin(uv.yx*10.0+time*1230.5)+cos(uv.xy*10.0+time*3122.24))*0.002 + (uv-mouse)*0.95 ).a - 0.03);
  
	gl_FragColor = mix(gl_FragColor, vec4(1.0), col );

}