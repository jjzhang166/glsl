
#ifdef GL_ES
precision highp float;
#endif
//Test
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float dist(float x, float y) { return x*x+y*y; }
float pallo(float px, float py) {
	vec2 position = gl_FragCoord.xy / resolution.y;
	float x = position.x;
	float y = position.y;
	float r = 0.2;
	return 1.0-min(floor(dist(x-px,y-py)/r), 1.0);
}

vec3 hassupallot() {
	vec2 position = gl_FragCoord.xy / resolution.y;

	float color = 0.0;
	float color2 = 0.0;
	float color3 = 0.0;
	float x = position.x;
	float y = position.y;
	float ox = 0.25;
	float oy = 0.5;
	float r = 0.42;
	float a = time*0.7;
	color += pallo(ox+sin(a)*r,oy+cos(a)*r);
	color += pallo(ox+sin(a+radians(90.0))*r,oy+cos(a+radians(90.0))*r);
	color += pallo(ox+sin(a+radians(180.0))*r,oy+cos(a+radians(180.0))*r);
	color += pallo(ox+sin(a+radians(270.0))*r,oy+cos(a+radians(270.0))*r);
	a = time*1.32;
	color2 += pallo(ox+sin(a+radians(45.0))*r,oy+cos(a+radians(45.0))*r);
	color3 += pallo(ox+sin(a+radians(135.0))*r,oy+cos(a+radians(135.0))*r);
	color2 += pallo(ox+sin(a+radians(225.0))*r,oy+cos(a+radians(225.0))*r);
	color3 += pallo(ox+sin(a+radians(315.0))*r,oy+cos(a+radians(315.0))*r);

	a = time*1.0;	
	color += pallo(ox+sin(-a)*r,oy+cos(-a)*r);
	color += pallo(ox+sin(-a+radians(90.0))*r,oy+cos(-a+radians(90.0))*r);
	color += pallo(ox+sin(-a+radians(180.0))*r,oy+cos(-a+radians(180.0))*r);
	color += pallo(ox+sin(-a+radians(270.0))*r,oy+cos(-a+radians(270.0))*r);

	a = time*0.63;
	color2 += pallo(ox+sin(-a+radians(45.0))*r,oy+cos(-a+radians(45.0))*r);
	color3 += pallo(ox+sin(-a+radians(135.0))*r,oy+cos(-a+radians(135.0))*r);
	color2 += pallo(ox+sin(-a+radians(225.0))*r,oy+cos(-a+radians(225.0))*r);
	color3 += pallo(ox+sin(-a+radians(315.0))*r,oy+cos(-a+radians(315.0))*r);

	color *= 0.25;
	color2 *= 0.25;
	color3 *= 0.25;
	//color *= sin( time / 0.50 ) * 0.5;

	return vec3(color*.7 + color2*.2 + color3*.3
	         + color3*sin(color*.1+color2*.3+color3+time*2.0)*.6,
	       color*.2 + color2*.3 + color3*.5
	         + color2*sin(color+color2*.3+color3*.2+time/3.2)*.6,
	       color*.1 + color2*.4 + color3*.2
	         + color*sin( color+color2*.3+color3*.2 + time *3.7 ) * 0.65
	       
	      );
} 

vec3 spiraali() {
	vec2 position = gl_FragCoord.xy / resolution.y;

	float color = 0.0;
	float color2 = 0.0;
	float color3 = 0.0;
	float ox = 0.25;
	float oy = 0.5;

	float pixelsize = 5.0 + sin(time*2.0) * 14.0/max(3.0 - (ox-position.x+oy-position.y), 1.0);
	float x = floor(position.x*resolution.y/pixelsize) / resolution.y*pixelsize;
	float y = floor(position.y*resolution.y/pixelsize) / resolution.y*pixelsize;
		
	float dx = ox-x;
	float dy = oy-y;

	float a = atan(dy,dx) + sqrt(dx*dx+dy*dy)*1.5*sin(time);
	float a2 = atan(dy,dx) - sqrt(dx*dx+dy*dy)*1.5*cos(time);
	
	return vec3(
		sin(time*4.0-10.0*a)+.4,
		sin(time*4.0+10.0*a2)+.4,
		sin(time*4.0-10.0*(a+radians(360.0/10.0)*.5))+.4
		);
}

void main( void ) {

	vec3 pallocolor = hassupallot();
	vec3 spicolor = spiraali();
	gl_FragColor = vec4(
		pallocolor*.8
		+ spicolor*.5, 1.0 );

}
