#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 pos = gl_FragCoord.xy;
	//pos.x += sin(time)*50.0;
	//pos.y += cos(time)*50.0;
	vec2 m = mouse;
	float r = 0.0;
	float g = 0.0;
	float b = 0.0;
	float sizeW =	150.0;
	float sizeH = 	100.0;
	
	float quadNumX = floor(resolution.x/sizeW);
	float quadRowX = floor(pos.x/sizeW);
	float quadNumY = resolution.y/sizeH;
	float quadRowY = floor(pos.y/sizeH);
	sizeW += cos(quadRowX+time)*10.0;
	sizeH += sin(quadRowY+time)*50.0;
	
	r += (1.0+sin(time*0.3))*0.5;
	g += (1.0+sin(time*0.5))*0.5;
	b += (1.0+cos(time*0.7))*0.5;
	
	float mx = mod(pos.x,sizeW);
	float my = mod(pos.y,sizeH);
	

	if(mx/my >= (sizeW/sizeH)){
		r += mod(pos.x,sizeW)/sizeW * mx/sizeH;
		g += my/sizeH;
	}
	else {
		g = mod(pos.y,sizeH)/sizeH * my/sizeH;
		//b = mx/sizeH;
		//r = my/sizeW;
	}
	
	
	vec3 rgb = vec3(r,g,b);
	rgb *= 0.5;
	
	gl_FragColor = vec4( rgb, 1.0 );

}