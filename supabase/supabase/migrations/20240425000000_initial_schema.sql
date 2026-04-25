-- Create users table
create table if not exists public.users (
    id uuid references auth.users(id) on delete cascade not null primary key,
    email text unique not null,
    name text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security
alter table public.users enable row level security;

-- Create policies for users
create policy "Users can view their own profile"
    on public.users for select
    using (auth.uid() = id);

create policy "Users can update their own profile"
    on public.users for update
    using (auth.uid() = id);

-- Create bills table (contas a pagar)
create table if not exists public.bills (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references auth.users(id) on delete cascade not null,
    name text not null,
    description text,
    amount decimal(10, 2) not null,
    due_date date not null,
    is_recurring boolean default false,
    recurring_interval text check (recurring_interval in ('weekly', 'monthly', 'yearly')),
    is_paid boolean default false,
    paid_at timestamp with time zone,
    paid_amount decimal(10, 2),
    category text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security for bills
alter table public.bills enable row level security;

-- Create policies for bills
create policy "Users can view their own bills"
    on public.bills for select
    using (auth.uid() = user_id);

create policy "Users can insert their own bills"
    on public.bills for insert
    with check (auth.uid() = user_id);

create policy "Users can update their own bills"
    on public.bills for update
    using (auth.uid() = user_id);

create policy "Users can delete their own bills"
    on public.bills for delete
    using (auth.uid() = user_id);

-- Create payments history table
create table if not exists public.payments (
    id uuid default gen_random_uuid() primary key,
    bill_id uuid references public.bills(id) on delete cascade not null,
    user_id uuid references auth.users(id) on delete cascade not null,
    amount decimal(10, 2) not null,
    payment_date timestamp with time zone default timezone('utc'::text, now()) not null,
    payment_method text,
    notes text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security for payments
alter table public.payments enable row level security;

-- Create policies for payments
create policy "Users can view their own payments"
    on public.payments for select
    using (auth.uid() = user_id);

create policy "Users can insert their own payments"
    on public.payments for insert
    with check (auth.uid() = user_id);

-- Create function to update updated_at timestamp
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = timezone('utc'::text, now());
    return new;
end;
$$ language plpgsql;

-- Create triggers for updated_at
create trigger update_users_updated_at
    before update on public.users
    for each row execute function public.handle_updated_at();

create trigger update_bills_updated_at
    before update on public.bills
    for each row execute function public.handle_updated_at();

-- Create indexes for better performance
create index if not exists idx_bills_user_id on public.bills(user_id);
create index if not exists idx_bills_due_date on public.bills(due_date);
create index if not exists idx_bills_is_paid on public.bills(is_paid);
create index if not exists idx_payments_bill_id on public.payments(bill_id);
create index if not exists idx_payments_user_id on public.payments(user_id);
