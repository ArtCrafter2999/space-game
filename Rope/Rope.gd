extends Node3D

@export var end_a : RopeEnd
@export var end_b : RopeEnd
@export var segment: PackedScene

func _ready() -> void:
	pass;
	var prev_segment : RopeEnd = end_a
	var new_segment: RopeSegment = segment.instantiate() as RopeSegment
	var distance = end_a.global_position.distance_to(end_b.global_position);
	_add_new_segment(prev_segment, new_segment);
	prev_segment = new_segment
	var segment_amount = round(distance / new_segment.length);
	
	for i in (segment_amount-1):
		#print(new_segment.global_position)
		new_segment = segment.instantiate() as RopeSegment 
		_add_new_segment(prev_segment, new_segment);
		prev_segment = new_segment
	prev_segment.connect_to(end_b.body)
	end_b.joint.queue_free();
	
	

func _add_new_segment(prev_segment: RopeEnd, new_segment: RopeSegment):
	add_child(new_segment);
	new_segment.global_position = prev_segment.joint.global_position
	new_segment.look_at(end_b.global_position)
	prev_segment.connect_to(new_segment.body);
