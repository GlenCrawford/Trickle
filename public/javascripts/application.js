document.observe("lightview:loaded", function() {
	$("time_entry_button").observe('click', function() {
		Lightview.show({
			href: '/time_entry_form',
			rel: 'ajax',
			title: 'Add a time entry',
			caption: 'Use this form to add a time entry to a job.',
			options: {
				autosize: true,
				closeButton: 'large',
				topclose: true,
				width: 400,
				ajax: {
					method: 'get',
					evalScripts: true,
					onSuccess: function(transport) {}
				}
			}
		});
	});
});

function disable_fields() {
	$('time_spent_hours').disable();
	$('time_spent_minutes').disable();
	$('notes').disable();
	$('need_extra_time').disable();
	$('extra_time_hours').disable();
	$('extra_time_minutes').disable();
}

function enable_fields() {
	$('time_spent_hours').enable();
	$('time_spent_minutes').enable();
	$('notes').enable();
	$('need_extra_time').enable();
	$('time_spent_hours').focus();
}

function toggle_extra_time() {
	if ($('need_extra_time').checked) {
		$('extra_time_hours').enable();
		$('extra_time_minutes').enable();
		$('extra_time_hours').focus();
	}
	else {
		$('extra_time_hours').disable();
		$('extra_time_minutes').disable();
	}
}

function get_tasks() {
	$('throwaway').remove();
	$('fetching_tasks_loading_image').show();
	new Ajax.Request('/time_entry_form_get_tasks', {
		method: 'get',
		parameters: 'job_id=' + $('job_id').getValue(),
		onSuccess: function(transport) {
			$('task_id').clear();
			var tasks = transport.responseText.evalJSON();
			$('task_id').options.add(new Option("[Okay, now select a task]", ""));
			setDropDown($('task_id'), tasks, function(e) {
				return new Option(e.task.name, e.task.id);
			});
			$('fetching_tasks_loading_image').hide();
			$('task_id').show();
			$('task_id').focus();
		}
	});
}

function setDropDown(field, data, method, index) {  
	field.options.length = index == null ? 1 : index;  
	data.each(  
		function(e) {  
			field.options.add(method(e));  
		}  
	);  
}

HTMLSelectElement.prototype.clear = function() {
	while (this.length > 0) {
		this.remove(0);
	}
}