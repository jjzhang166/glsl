#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D backbuffer;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define SCALE 0.2

#define COLOR_BACK vec4(0.4, 0.4, 0.5, 1.0)
#define COLOR_FRONT vec4(1.0, 1.0, 1.0, 1.0)

#define PSAMPLE(ppx, ppy) texture2D(backbuffer, (vec2(ppx + 0.5, ppy + 0.5) / SCALE / resolution))

bool rule ( float px, float py ) {
	
	
	float p = (PSAMPLE(px - 1.0, py).r > 0.99) ? 1.0 : 0.0;
	float q = (PSAMPLE(px,	   py).r > 0.99) ? 1.0 : 0.0;
	float r = (PSAMPLE(px + 1.0, py).r > 0.99) ? 1.0 : 0.0;
	
	
	
	return mod(p + r, 2.0) > 0.5;
}

void main( void ) {

	vec2 pixel = ( gl_FragCoord.xy * SCALE );
	pixel.x = floor(pixel.x);
	pixel.y = floor(pixel.y);
	
	gl_FragColor = COLOR_BACK;
	
	float st = resolution.x * 0.5 * SCALE/* + sin(time * 4.0) * 40.0*/;
	
	if(pixel.y > 1.0) {
	gl_FragColor = (rule(pixel.x, pixel.y - 1.0) ? COLOR_FRONT : COLOR_BACK);
	}
	if(pixel.x > st - 0.5 && pixel.x < st + 0.5 && pixel.y < 1.5 && (mouse.y < 0.8 || mouse.x < 0.8))
		gl_FragColor = COLOR_FRONT;
	
	if(mod(time, 2.8) > 2.1 && mouse.y > 0.8 && mouse.x > 0.8)
	{
		gl_FragColor = PSAMPLE(pixel.x, pixel.y + 3.0);
	}
		
}