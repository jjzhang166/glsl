#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D backbuffer;

vec2 rand(vec2 pos){
	return fract((pow(pos + 2.0, pos.xy + 2.0) * 22222.0));
}

vec2 rand2(vec2 pos){
	return rand(rand(pos));
}

void main(){
	vec2 pos = (gl_FragCoord.xy * 2.0 - resolution) / resolution.y;
	
	float theta = time * 3.0;
	vec2 ballPos = vec2(cos(theta), sin(theta)) * 0.5;
	vec2 texPos = vec2(gl_FragCoord.xy / resolution);
	vec2 texDelta = vec2(5.0 / resolution);
	
	if(distance(pos, ballPos) < 0.3){
		gl_FragColor = vec4(0.75, 0.25, 0.1, 1.0);
	}else if(gl_FragCoord.y < 4.0){
		gl_FragColor = vec4(rand(pos + fract(time) * 0.1).xyy, 1.0) * vec4(1.0, 0.25, 0.25, 1.0);
	}else{
		gl_FragColor = 
			texture2D(backbuffer, texPos + vec2(0.0, -texDelta.y)) * 0.33 +
			texture2D(backbuffer, texPos + vec2(texDelta.x, -texDelta.y)) * 0.33 +
			texture2D(backbuffer, texPos + vec2(-texDelta.x, -texDelta.y)) * 0.33;
	}
}