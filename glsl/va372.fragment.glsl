#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec4 live = vec4(0.5,1.0,0.7,1.);
vec4 dead = vec4(0.,0.,0.,1.);
vec4 blue = vec4(0.,0.,1.,1.);

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;
	vec4 me = texture2D(backbuffer, position);
	float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);

	if (me.r == 0.0) {
		me.b = 0.9 + 0.45 * rnd1 - 2.2 * length(position-vec2(0.5, 0.5));
		me.r = 0.004;
		if (length(position-vec2(0.5, 0.5)) < 0.03) {
			me.g = rnd1;
		}
	} else {
		float ideal = 2.1;
		float idealadjust = 3.2;
		float deadzone = 0.3;
		float neighborbias = 1.8;
		float diagonalbias= 1.0;
		float distantbias= 0.6;
		float waterrate = 0.004;
		float drinkrate = 0.93;

		float sum = 0.;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., 0.)).g * neighborbias;
		sum += texture2D(backbuffer, position + pixel * vec2(1., 0.)).g * neighborbias;
		sum += texture2D(backbuffer, position + pixel * vec2(0., -1.)).g * neighborbias;
		sum += texture2D(backbuffer, position + pixel * vec2(0., 1.)).g * neighborbias;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., -1.)).g * diagonalbias;
		sum += texture2D(backbuffer, position + pixel * vec2(-1., 1.)).g * diagonalbias;
		sum += texture2D(backbuffer, position + pixel * vec2(1., -1.)).g * diagonalbias;
		sum += texture2D(backbuffer, position + pixel * vec2(1., 1.)).g * diagonalbias;
		sum += texture2D(backbuffer, position + pixel * vec2(-2., 0.)).g * distantbias;
		sum += texture2D(backbuffer, position + pixel * vec2(2., 0.)).g * distantbias;
		sum += texture2D(backbuffer, position + pixel * vec2(0., -2.)).g * distantbias;
		sum += texture2D(backbuffer, position + pixel * vec2(0., 2.)).g * distantbias;

		ideal += me.g * idealadjust;
		float diff = 1.1 - abs(sum - ideal);
		if (diff > deadzone) {
			float original_b = me.b;
			me.b *= drinkrate;
			float water_consumed = original_b - me.b; 
			me.g += ((diff - deadzone) * 0.3 * water_consumed / (1.0 - drinkrate));
		} else if (diff < 0.0) {
			me.g += (diff * 0.3);
		} else {
			me.g -= 0.3;
		}

		me.b += rnd1*waterrate;
	}
	gl_FragColor = me;
}
