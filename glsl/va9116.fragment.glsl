#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

#define KERNEL_SIZE 9
float kernel[KERNEL_SIZE];
uniform float width;

vec2 offset[KERNEL_SIZE];

float ru = 0.4; // rate of diffusion of U
float rv = 0.2; // rate of diffusion of V
float f = 0.1; // some coupling parameter
float k = 0.02; // another coupling parameter

void main( void ) {
	
	vec2 texCoord = gl_FragCoord.xy; // center coordinates
	float w = 1.0/width;
	float h = 1.0/width;
	float w2 = w*2.0;
	float h2 = h*2.0;
	
	kernel[0] = 0.707106781;
	kernel[1] = 1.0;
	kernel[2] = 0.707106781;
	kernel[3] = 1.0;
	kernel[4] =-6.82842712;
	kernel[5] = 1.0;
	kernel[6] = 0.707106781;
	kernel[7] = 1.0;
	kernel[8] = 0.707106781;
	
	offset[0] = vec2( -w, -h);
	offset[1] = vec2(0.0, -h);
	offset[2] = vec2( w, -h);
	
	offset[3] = vec2( -w, 0.0);
	offset[4] = vec2(0.0, 0.0);
	offset[5] = vec2( w, 0.0);
	
	offset[6] = vec2( -w, h);
	offset[7] = vec2(0.0, h);
	offset[8] = vec2( w, h);
	
	//Recursively shading Pascal's triangle mod n.
	float n=2.0;//Change n to see what happens. Don't be afraid to try non-integer values as well!
	//Try moving your mouse to disturb the pattern.
	float m=n-1.0;
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pix=(1.0/resolution.xy);
	if(gl_FragCoord.x<=0.5||gl_FragCoord.y<=0.5){
		gl_FragColor=vec4(0.0,0.0,0.0,1.0);
	}
	else if(gl_FragCoord.x<=1.5&&gl_FragCoord.y<=1.5){
		gl_FragColor = vec4( 1.0,1.0,1.0, 1.0 );
	}
	else if(length((position-mouse)*vec2(resolution.x/resolution.y,1.0))<0.01){
		gl_FragColor = vec4( 0.0,0.0,0.0, 1.0 );
	}
	else{
			
		float center = -(4.0+4.0/sqrt(2.0)); // -1 * other weights
		float diag = 1.0/sqrt(2.0); // weight for diagonals
		vec2 p = gl_FragCoord.st; // center coordinates
		vec2 c = texture2D(backbuffer, p).rg; // center value
		
		vec2 sum = vec2( 0.0, 0.0 );
   
		for( int i=0; i<KERNEL_SIZE; i++ )
		{
			vec2 tmp = texture2D( backbuffer, texCoord + offset[i] ).rb;
			sum += tmp * kernel[i];
		}  
		
		float u = c.r; // compute some temporary
		float v = c.g; // values which might save
		float lu = sum.r; // a few GPU cycles
		float lv = sum.g;
		float uvv = u * v * v;
		//============================================================
		float du = ru * lu - uvv + f * (1.0 - u); // Gray-Scott equation
		float dv = rv * lv + uvv - (f + k) * v; // diffusion+-reaction
		//============================================================
		u += 0.6*du; // semi-arbitrary scaling (reduces blow-ups?)
		v += 0.6*dv;
		gl_FragColor = vec4(clamp(u, 0.0, 1.0), clamp(v, 0.0, 1.0), 0.0, 1.0); // output new (U,V)
		
		/*float left=texture2D(backbuffer,position-vec2(pix.x,0.0)).x*m;
		float bottom=texture2D(backbuffer,position-vec2(0.0,pix.y)).x*m;
		float value=mod(left+bottom,n)/m;
		
		gl_FragColor = vec4(value,value,value, 1.0 );*/
	}
}
//Made by willy-vvu. Check out my github page at http://github.com/willy-vvu or my homepage at http://willy.herokuapp.com