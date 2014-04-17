#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// exact motion blur test: baby-rabbit - http://fernlightning.com

// spread must be +ve, mblur occurs along the x-axis
float circle(vec2 pos, float spread) {
	float dx2 = 1.0-pos.y*pos.y;
	if(dx2 < 0.0) return 0.0; // trap nan
	float dx = sqrt(dx2);
	if(spread < 0.001) return (abs(pos.x)>dx)?0.0:1.0; // trap div0
	float sx = 0.5 - abs(pos.x/spread);
	dx /= spread;
	if(dx < sx) return dx*2.0;
	return clamp(dx + sx, 0.0, 1.0);
}

// can we really compose like this?
float ring(vec2 pos, float spread, float d) {
	return clamp(circle(pos, spread) - circle(pos*d, spread*d), 0.0, 1.0);
}


void main(void)
{
    vec2 pixel = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    pixel = pixel * 6.0;

   float t = time*2.0;
   pixel.x += 2.0*cos(t);
   float spread = 0.5*abs(sin(t)); 

   float a = ring(pixel, spread, 2.0);

   a += circle(pixel+vec2(0.0,-3.0), spread);

    a = pow(a, 1.0/2.2); // convert to gamma
    gl_FragColor=vec4(a,a,a, 1.0); 
}