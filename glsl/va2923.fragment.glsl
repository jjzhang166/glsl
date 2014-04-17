#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

/**
 * By Vincent Petry <PVince81@yahoo.fr>
 */
void main( void ) {
	float PI = 3.14159265358979323846264;
	float barSize = resolution.y * 0.3;
	float offset = sin(gl_FragCoord.x / 50.0) * sin(time * 5.0) * 20.0;
	float vOffset = sin(gl_FragCoord.y / 50.0) * sin(time * 3.0) * 20.0;
	//float barPos = ( resolution.y - barSize ) * ( sin(time) + 1.0 ) / 2.0;	
	//float vBarPos = ( resolution.x - barSize ) * ( sin(time) + 1.0 ) / 2.0;	
	float barPos = mouse.y * resolution.y - barSize / 2.0 + offset;
	float vBarPos = mouse.x * resolution.x - barSize / 2.0 + vOffset;
	
	vec4 col = vec4(0.0, 0.0, 0.0, 0.0);
	if (mod(gl_FragCoord.x, 1.0) == 1.0) {
		col = vec4(1.0, 1.0, 0.0, 1.0);
	}
	
	float b = 1.0;
	bool hasH = false;
	if (gl_FragCoord.y >= barPos && gl_FragCoord.y < (barPos + barSize)){
		float offset = (gl_FragCoord.y - barPos) / barSize;
		offset = abs(sin(offset * PI));
		float offset2 = (offset - 0.75) * 2.0;
		col = mix(col, vec4(offset, offset2, 0.0, 0.0), offset);
		hasH = true;
	}
	if (gl_FragCoord.x >= vBarPos && gl_FragCoord.x < (vBarPos + barSize)){
		float offset = (gl_FragCoord.x - vBarPos) / barSize;
		offset = abs(sin(offset * PI));
		float offset2 = (offset - 0.75) * 2.0;
		vec4 col2 = vec4(offset2, offset / 2.0,offset,offset);
		//col = vec4((col.r + col2.r * col2.a) / 2.0, (col.g + col2.g* col2.a) / 2.0, (col.b + col2.b * col2.a) / 2.0, 1.0);
		col = mix(col, col2, col2.a);
	}
	gl_FragColor = col;
}