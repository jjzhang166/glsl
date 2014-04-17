// https://www.shadertoy.com/view/lsf3RH

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 blurX(vec2 co, float radius) {
    vec4 average = vec4(0, 0, 0, 0);
    
    float sampleSize = 1.0;

    int n = 0;
        float x = (radius - sampleSize) * -1.0;
    
    for (int i = 0; i < 50; i++) {
        if (x > radius) break;

        vec2 spoint = vec2(x / resolution.x, 0);
        average += texture2D(backbuffer, co + spoint);
        n++;

        x += sampleSize;    
    }

    return average / float(n);
}

vec4 blurY(vec2 co, float radius) {
    vec4 average = vec4(0, 0, 0, 0);
    
    float sampleSize = 1.0;

    int n = 0;
        float y = (radius - sampleSize) * -1.0;
    
    for (int i = 0; i < 50; i++) {
        if (y > radius) break;

        vec2 spoint = vec2(0, y / resolution.y);
        average += texture2D(backbuffer, co + spoint);
        n++;

        y += sampleSize;    
    }

    return average / float(n);
}

void main(void) 
{
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec4 source = texture2D(backbuffer, position);

	float ref = texture2D(backbuffer, vec2(0.0, 0.0)).a;
	bool isRefPixel = gl_FragCoord.x <= 1.0 && gl_FragCoord.y <= 1.0;
	
	if (ref == 0.0) {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0.1);
		} else {
			float random = rand(vec2(position.x * time, position.y * time));
			float colour = (random * 2.0) - 1.0;
			colour = source.a + colour;
			gl_FragColor = vec4(source.r, source.g, source.b, colour);				
		}
	} else if (ref < 0.2) {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0.3);
		} else {
			gl_FragColor = vec4(source.r, source.g, source.b, blurY(position, 5.0).a);			
		}
	} else if (ref < 0.4) {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0.5);
		} else {
			gl_FragColor = vec4(source.r, source.g, source.b, blurX(position, 5.0).a);			
		}
	} else if (ref < 0.5) {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0.6);
		} else {
			gl_FragColor = vec4(source.r, source.g, blurY(position, 10.0).a, source.a);			
		}
	} else if (ref < 0.7) {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0.8);
		} else {
			gl_FragColor = vec4(source.r, source.g, blurX(position, 10.0).b, source.a);			
		}		
	} else {
		if (isRefPixel) {
			gl_FragColor = vec4(0, 0, 0, 0);
		} else {
			float colourA = source.a;
			float colourB = source.b;
			float colour = source.r;
			if (colourA > colourB) {
				colour += 0.1;
			} else {
				colour -= 0.1;
			}
			gl_FragColor = vec4(colour, colour, source.b, colour);
		}
	};
}