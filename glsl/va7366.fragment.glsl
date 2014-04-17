#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	float pix=0.001;
	float thresh=0.5;
	vec2 position =gl_FragCoord.xy / resolution.xy;
	if(length(position-mouse )<0.01){
		if(fract(sin(dot(position ,vec2(12.9898,78.233))) * 43758.5453)>0.5){
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
	}
	else{
		vec4 sum=texture2D(backbuffer,position+vec2(pix,-pix))
			+texture2D(backbuffer,position+vec2(pix,0))
			+texture2D(backbuffer,position+vec2(pix,pix))
			+texture2D(backbuffer,position+vec2(0,-pix))
			+texture2D(backbuffer,position+vec2(0,pix))
			+texture2D(backbuffer,position+vec2(-pix,-pix))
			+texture2D(backbuffer,position+vec2(-pix,0))
			+texture2D(backbuffer,position+vec2(-pix,pix));
		if(texture2D(backbuffer,position).x<thresh){//Dead cell becomes alive with 3 living neighbors
			if(abs(sum.x-3.0)<0.5){
				gl_FragColor=vec4(1.0,1.0,1.0,1.0);
			}
			else{
				gl_FragColor=vec4(0.0,0.0,0.0,1.0);
			}
		}
		else{//Living cell stays alive with 2 or 3
			if(abs(sum.x-2.5)<1.0){
				gl_FragColor=vec4(1.0,1.0,1.0,1.0);
			}
			else{
				gl_FragColor=vec4(0.0,0.0,0.0,1.0);
			}
		}
	}

}