#ifdef GL_ES
precision mediump float;
#endif

//MoltenPlastic by CuriousChettai@gmail.com

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 uPos = gl_FragCoord.xy/resolution.y;
	uPos += vec2(-resolution.x/resolution.y/2.0, -0.5);
	
	uPos.x += sin(uPos.x + uPos.y*4.0)*0.5;
	float temp = (sin(uPos.x*10.0)/10.0 + sin(uPos.x*50.0-time)/40.0 + abs(sin(uPos.x*100.0+time))/20.0 + abs(sin(uPos.x*1090.0+time))/50.0 +  abs(sin(uPos.x*10000.0))/30.0 + (sin(uPos.y*5.0)+1.0)/10.0 + 0.2)/1.5;
	vec3 bkg = vec3(temp*0.5, temp*0.1, temp*0.9);
	
	temp = 0.0;
	for(int i=0; i<151; i++){
		vec2 point = vec2((sin(float(i)*21.0)-sin(float(i)*3.0))/1.0, (sin(float(i)+22.0)-cos(float(i)*3.0))/2.0 );
		point = vec2((point.x-uPos.x)*10.0, point.y-uPos.y);
		point.y = fract(point.y - time/5.0) - 0.5;
		temp += 1.0/pow(distance(point, uPos), 1.1)*0.001;

	}
	vec3 stars = vec3(temp);
	
	gl_FragColor = vec4(bkg+stars, 1.0);

}