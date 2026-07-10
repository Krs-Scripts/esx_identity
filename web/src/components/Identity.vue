<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { Form, Field, useForm } from 'vee-validate';
import * as yup from 'yup'
import moment from 'moment'

const schema = yup.object({
    firstname: yup.string().required('Firstname is required').min(3, 'Firstname must be at least 3 characters'),
    lastname: yup.string().required('Lastname is required').min(3, 'Lastname must be at least 3 characters'),
    dob: yup.date()
        .required('Date of Birth is required')
        .min(new Date("1900-01-01"), "Date is too early")
        .max(moment().subtract(1, 'years').toDate(), "You need to be atleast 1 year old"),
    gender: yup.string().required('Gender is required'),
    height: yup.number().required('Height is required').min(120, 'Minimum height is 120cm').max(220, 'Maximum height is 220cm').typeError('Amount must be a number'),
})

const { handleSubmit, setFieldValue, errors, resetForm } = useForm({
    validationSchema: schema,
    initialValues: { gender: 'm' },
})

const onSubmit = handleSubmit(
    (values) => {
        fetch("http://esx_identity/register", {
            method: "POST",
            body: JSON.stringify({
                firstname: values.firstname,
                lastname: values.lastname,
                dateofbirth: moment(values.dob).format("DD/MM/YYYY"),
                sex: values.gender,
                height: values.height,
            }),
        });
    },
    ({ errors }) => {
        console.warn("[esx_identity] Campi non validi:", errors)
    }
)

const showPicker = ref(false)
const viewDate = ref(moment())
const selectedDate = ref(null)
const view = ref('days')   // 'days' | 'months' | 'years'

const weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
const monthNames = ['January','February','March','April','May','June','July','August','September','October','November','December']
const monthShort = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

const displayValue = computed(() =>
    selectedDate.value ? selectedDate.value.format('DD/MM/YYYY') : ''
)

const monthLabel = computed(() =>
    `${monthNames[viewDate.value.month()]} ${viewDate.value.year()}`
)

const days = computed(() => {
    const start = viewDate.value.clone().startOf('month')
    const end = viewDate.value.clone().endOf('month')
    const cells = []
    let offset = (start.day() + 6) % 7
    for (let i = 0; i < offset; i++) cells.push(null)
    for (let d = 1; d <= end.date(); d++) {
        cells.push(viewDate.value.clone().date(d))
    }
    return cells
})

const yearRangeStart = ref(moment().year() - 6)
const years = computed(() => {
    const arr = []
    for (let y = yearRangeStart.value; y < yearRangeStart.value + 12; y++) arr.push(y)
    return arr
})

const headerLabel = computed(() => {
    if (view.value === 'days') return monthLabel.value
    if (view.value === 'months') return viewDate.value.year()
    return `${years.value[0]} - ${years.value[years.value.length - 1]}`
})

const prev = () => {
    if (view.value === 'days') viewDate.value = viewDate.value.clone().subtract(1, 'month')
    else if (view.value === 'months') viewDate.value = viewDate.value.clone().subtract(1, 'year')
    else yearRangeStart.value -= 12
}
const next = () => {
    if (view.value === 'days') viewDate.value = viewDate.value.clone().add(1, 'month')
    else if (view.value === 'months') viewDate.value = viewDate.value.clone().add(1, 'year')
    else yearRangeStart.value += 12
}

const cycleHeader = () => {
    if (view.value === 'days') view.value = 'months'
    else if (view.value === 'months') {
        yearRangeStart.value = viewDate.value.year() - 6
        view.value = 'years'
    }
}

const selectYear = (y) => {
    viewDate.value = viewDate.value.clone().year(y)
    view.value = 'months'
}

const selectMonth = (m) => {
    viewDate.value = viewDate.value.clone().month(m)
    view.value = 'days'
}

const isSelected = (day) =>
    day && selectedDate.value && day.isSame(selectedDate.value, 'day')

const isToday = (day) => day && day.isSame(moment(), 'day')

const isCurrentMonth = (m) =>
    selectedDate.value && selectedDate.value.month() === m && selectedDate.value.year() === viewDate.value.year()

const isCurrentYear = (y) =>
    selectedDate.value && selectedDate.value.year() === y

const togglePicker = () => {
    showPicker.value = !showPicker.value
    if (showPicker.value) view.value = 'days'
}

const selectDay = (day) => {
    if (!day) return
    selectedDate.value = day.clone()
    setFieldValue('dob', day.toDate())   
    showPicker.value = false
}

const resetAll = () => {
    resetForm({ values: { gender: 'm' } })
    selectedDate.value = null
    viewDate.value = moment()
    showPicker.value = false
    view.value = 'days'
}

const handleEnableUi = (event) => {
    if (event.data && event.data.type === 'enableui' && event.data.enable) {
        resetAll()
    }
}

onMounted(() => {
    window.addEventListener('message', handleEnableUi)
})

onBeforeUnmount(() => {
    window.removeEventListener('message', handleEnableUi)
})
</script>

<template>
  <div class="identity__bg">
    <div class="identity">
        <div class="identity__header">
            <h1 class="identity__title">
                <span class="identity__title-main">IDENTITY</span>
                <span class="identity__title-script">Creator</span>
            </h1>
        </div>

        <form class="identity__form" id="register" @submit.prevent="onSubmit">

            
            <div class="identity__field">
                <div class="identity__field-head">
                    <span class="identity__icon">
                        <span class="identity__icon-inner"><i class="fas fa-user"></i></span>
                    </span>
                    <div class="identity__field-text">
                        <label for="firstname">First & Last Name</label>
                        <p class="identity__desc">Enter your character's first and last name.</p>
                    </div>
                </div>
                <div class="identity__field-body">
                    <div class="identity__namerow">
                        <div class="identity__input-validation">
                            <Field id="firstname" type="text" name="firstname" placeholder="First Name" validateOnInput />
                        </div>
                        <div class="identity__input-validation">
                            <Field id="lastname" type="text" name="lastname" placeholder="Last Name" validateOnInput />
                        </div>
                    </div>
                </div>
            </div>

            
            <div class="identity__field">
                <div class="identity__field-head">
                    <span class="identity__icon">
                        <span class="identity__icon-inner"><i class="fas fa-venus-mars"></i></span>
                    </span>
                    <div class="identity__field-text">
                        <label for="gender">Gender</label>
                        <p class="identity__desc">Select your character's gender.</p>
                    </div>
                </div>
                <div class="identity__field-body">
                    <div class="identity__gender">
                        <Field type="radio" id="male" value="m" name="gender" validateOnInput />
                        <label for="male" class="identity__gender-btn">
                            <i class="fas fa-mars"></i> Male
                        </label>
                        <Field type="radio" id="female" value="f" name="gender" validateOnInput />
                        <label for="female" class="identity__gender-btn">
                            <i class="fas fa-venus"></i> Female
                        </label>
                    </div>
                </div>
            </div>

            
            <div class="identity__field">
                <div class="identity__field-head">
                    <span class="identity__icon">
                        <span class="identity__icon-inner"><i class="fas fa-birthday-cake"></i></span>
                    </span>
                    <div class="identity__field-text">
                        <label for="dob">Date of Birth</label>
                        <p class="identity__desc">Enter your date of birth (day, month, year).</p>
                    </div>
                </div>
                <div class="identity__field-body">
                    <div class="identity__date">
                        <div class="identity__date-input" @click="togglePicker">
                            <span :class="['identity__date-value', { 'is-placeholder': !displayValue }]">
                                {{ displayValue || 'dd/mm/yyyy' }}
                            </span>
                            <i class="fas fa-calendar-alt"></i>
                        </div>

                        
                        <transition name="picker-fade">
                            <div v-if="showPicker" class="identity__calendar">
                                <div class="identity__calendar-head">
                                    <button type="button" class="identity__cal-nav" @click="prev">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <span class="identity__cal-month" @click="cycleHeader">{{ headerLabel }}</span>
                                    <button type="button" class="identity__cal-nav" @click="next">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>

                              
                                <template v-if="view === 'days'">
                                    <div class="identity__cal-weekdays">
                                        <span v-for="d in weekDays" :key="d">{{ d }}</span>
                                    </div>
                                    <div class="identity__cal-grid">
                                        <button
                                            v-for="(day, i) in days"
                                            :key="i"
                                            type="button"
                                            class="identity__cal-day"
                                            :class="{
                                                'is-empty': !day,
                                                'is-selected': isSelected(day),
                                                'is-today': isToday(day) && !isSelected(day)
                                            }"
                                            :disabled="!day"
                                            @click="selectDay(day)"
                                        >
                                            {{ day ? day.date() : '' }}
                                        </button>
                                    </div>
                                </template>

                               
                                <div v-else-if="view === 'months'" class="identity__cal-mygrid">
                                    <button
                                        v-for="(m, i) in monthShort"
                                        :key="m"
                                        type="button"
                                        class="identity__cal-cell"
                                        :class="{ 'is-selected': isCurrentMonth(i) }"
                                        @click="selectMonth(i)"
                                    >
                                        {{ m }}
                                    </button>
                                </div>

                          
                                <div v-else class="identity__cal-mygrid">
                                    <button
                                        v-for="y in years"
                                        :key="y"
                                        type="button"
                                        class="identity__cal-cell"
                                        :class="{ 'is-selected': isCurrentYear(y) }"
                                        @click="selectYear(y)"
                                    >
                                        {{ y }}
                                    </button>
                                </div>
                            </div>
                        </transition>
                    </div>
                </div>
            </div>

            <div class="identity__field">
                <div class="identity__field-head">
                    <span class="identity__icon">
                        <span class="identity__icon-inner"><i class="fas fa-ruler-vertical"></i></span>
                    </span>
                    <div class="identity__field-text">
                        <label for="height">Height</label>
                        <p class="identity__desc">Specify your height in centimeters.</p>
                    </div>
                </div>
                <div class="identity__field-body">
                    <div class="identity__input-validation">
                        <Field id="height" type="text" name="height" placeholder="175" validateOnInput />
                    </div>
                </div>
            </div>

            <button class="identity__submit" id="submit" type="submit">
                <i class="fas fa-user-plus"></i> CREATE
            </button>
        </form>
    </div>
  </div>
</template>

<style scoped>
</style>